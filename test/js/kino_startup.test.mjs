import test from "node:test";
import assert from "node:assert/strict";
import { init } from "../../priv/plotly_js/plotly_live.js";
import { browser, nextTurn } from "./browser_helpers.mjs";

function deferred() {
  let resolve;
  const promise = new Promise(done => { resolve = done; });
  return { promise, resolve };
}

function context(env) {
  const updates = new Map();
  return {
    updates,
    ctx: {
      root: env.el,
      pushEvent() {},
      handleEvent(name, handler) { updates.set(name, handler); }
    }
  };
}

const initial = { data: [{ type: "scatter", x: [1], y: [1] }], layout: { title: "$x$" } };
const latest = { data: [{ type: "scatter", x: [1], y: [9] }] };

test("an update during initial MathJax startup remains the displayed figure", async t => {
  const env = browser(t);
  const startup = deferred();
  window.MathJax = { typesetPromise() {}, startup: { promise: startup.promise } };
  const { ctx, updates } = context(env);
  let displayed;
  const order = [];
  env.plotly.newPlot = async (_root, data) => { order.push("newPlot"); displayed = data; };
  env.plotly.react = async (_root, data) => { order.push("react"); displayed = data; };

  init(ctx, JSON.stringify({ figureJson: JSON.stringify(initial), plotlyUrls: [], version: "4.1.2" }));
  await nextTurn();
  const update = updates.get("update")(JSON.stringify(latest));
  await nextTurn();
  startup.resolve();
  await update;
  await nextTurn();

  assert.deepEqual(order, ["newPlot", "react"]);
  assert.deepEqual(displayed, latest.data);
});

test("an update waits for the initial newPlot promise to finish", async t => {
  const env = browser(t);
  const rendering = deferred();
  const { ctx, updates } = context(env);
  let displayed;
  const order = [];
  env.plotly.newPlot = async (_root, data) => {
    order.push("newPlot started");
    await rendering.promise;
    displayed = data;
    order.push("newPlot finished");
  };
  env.plotly.react = async (_root, data) => { order.push("react"); displayed = data; };

  init(ctx, JSON.stringify({ figureJson: JSON.stringify({ data: initial.data }), plotlyUrls: [], version: "4.1.2" }));
  await nextTurn();
  const update = updates.get("update")(JSON.stringify(latest));
  await nextTurn();
  rendering.resolve();
  await update;
  await nextTurn();

  assert.deepEqual(order, ["newPlot started", "newPlot finished", "react"]);
  assert.deepEqual(displayed, latest.data);
});

test("successive updates finish in arrival order", async t => {
  const env = browser(t);
  const rendering = deferred();
  const { ctx, updates } = context(env);
  let displayed;
  const order = [];
  env.plotly.react = async (_root, data) => {
    const value = data[0].y[0];
    order.push(`start ${value}`);
    if (value === 2) await rendering.promise;
    displayed = data;
    order.push(`finish ${value}`);
  };

  init(ctx, JSON.stringify({ figureJson: JSON.stringify({ data: initial.data }), plotlyUrls: [], version: "4.1.2" }));
  await nextTurn();
  const first = updates.get("update")('{"data":[{"type":"scatter","y":[2]}]}');
  const second = updates.get("update")(JSON.stringify(latest));
  await nextTurn();
  rendering.resolve();
  await Promise.all([first, second]);

  assert.deepEqual(order, ["start 2", "finish 2", "start 9", "finish 9"]);
  assert.deepEqual(displayed, latest.data);
});

test("a failed update does not prevent later valid updates from rendering", async t => {
  const env = browser(t);
  const warning = t.mock.method(console, "warn", () => {});
  const { ctx, updates } = context(env);
  let displayed;
  const attempted = [];
  env.plotly.react = async (_root, data) => {
    const value = data[0].y[0];
    attempted.push(value);
    if (value === 2) throw new Error("invalid update");
    displayed = data;
  };

  init(ctx, JSON.stringify({ figureJson: JSON.stringify({ data: initial.data }), plotlyUrls: [], version: "4.1.2" }));
  await nextTurn();
  await assert.rejects(
    updates.get("update")('{"data":[{"type":"scatter","y":[2]}]}'),
    /invalid update/
  );
  await updates.get("update")(JSON.stringify(latest));

  assert.deepEqual(attempted, [2, 9]);
  assert.deepEqual(displayed, latest.data);
  assert.equal(warning.mock.callCount(), 1);
  assert.equal(warning.mock.calls[0].arguments[1].message, "invalid update");
});

function failFirstNewPlot(env) {
  const state = { displayed: undefined, newPlotCalls: 0 };
  env.plotly.newPlot = async (_root, data) => {
    state.newPlotCalls += 1;
    if (state.newPlotCalls === 1) throw new Error("invalid initial figure");
    state.displayed = data;
  };
  env.plotly.react = async (_root, data) => { state.displayed = data; };
  return state;
}

async function initWithFailedRender(t, env) {
  t.mock.method(console, "warn", () => {});
  t.mock.method(console, "error", () => {});
  const { ctx, updates } = context(env);
  init(ctx, JSON.stringify({ figureJson: JSON.stringify({ data: initial.data }), plotlyUrls: [], version: "4.1.2" }));
  await nextTurn();
  await nextTurn();
  return updates;
}

test("a valid update recovers after the initial render fails", async t => {
  const env = browser(t);
  const state = failFirstNewPlot(env);
  const updates = await initWithFailedRender(t, env);

  await updates.get("update")(JSON.stringify(latest));

  assert.deepEqual(state.displayed, latest.data);
});

test("events are registered once the chart recovers from a failed initial render", async t => {
  const env = browser(t);
  failFirstNewPlot(env);
  const updates = await initWithFailedRender(t, env);

  await updates.get("update")(JSON.stringify(latest)).catch(() => {});

  for (const name of ["plotly_click", "plotly_hover", "plotly_unhover", "plotly_relayout", "plotly_selected"]) {
    assert.equal((env.handlers.get(name) || []).length, 1, `${name} listener count`);
  }
});

import test from "node:test";
import assert from "node:assert/strict";
import { browser, freshModule, nextTurn, mathJaxScriptLoaded } from "./browser_helpers.mjs";

async function hook(t) {
  const env = browser(t);
  const { PlotlyChart } = await freshModule("../../priv/static/plotly_hook.js");
  const pushed = [];
  return { ...env, pushed, hook: { ...PlotlyChart, el: env.el, pushEvent: (...args) => pushed.push(args) } };
}

test("hook registers all events once, forwards unhover and cleans up", async t => {
  const env = await hook(t);
  env.hook.mounted();
  await nextTurn();
  const names = ["plotly_click", "plotly_hover", "plotly_unhover", "plotly_relayout", "plotly_selected"];
  assert.deepEqual([...env.handlers.keys()].sort(), [...names].sort());
  env.handlers.get("plotly_unhover")[0]({ points: [] });
  assert.deepEqual(env.pushed, [["plotly_event", { type: "plotly_unhover", data: { points: [], xvals: null, yvals: null, xPixel: null, yPixel: null } }]]);
  env.hook.updated();
  await nextTurn();
  for (const name of names) assert.equal(env.handlers.get(name).length, 1);
  env.hook.destroyed();
  assert.equal(env.observers[0].disconnected, true);
  for (const name of names) assert.equal(env.handlers.get(name).length, 0);
  assert.equal(env.calls.at(-1)[0], "purge");
});

for (const method of ["mounted", "updated"]) {
  test(`${method} waits for MathJax script and startup before plotting`, async t => {
    const env = await hook(t);
    env.el.dataset.figure = JSON.stringify({ data: [{ type: "scatter" }], layout: { title: "$x^2$" } });
    const startup = Promise.withResolvers();
    env.hook[method]();
    await nextTurn();
    assert.equal(env.scripts[0]?.src, "https://cdn.jsdelivr.net/npm/mathjax@4/tex-svg.js");
    assert.equal(env.calls.some(([name]) => ["newPlot", "react"].includes(name)), false);
    mathJaxScriptLoaded(env.scripts[0], startup);
    await nextTurn();
    assert.equal(env.calls.some(([name]) => ["newPlot", "react"].includes(name)), false);
    startup.resolve();
    await nextTurn();
    assert.equal(env.calls.filter(([name]) => name === (method === "mounted" ? "newPlot" : "react")).length, 1);
    env.hook.destroyed();
  });
}

test("hook does not load MathJax when the figure contains no math", async t => {
  const env = await hook(t);
  env.hook.mounted();
  await nextTurn();
  assert.equal(env.scripts.length, 0);
  assert.equal(env.calls.filter(([name]) => name === "newPlot").length, 1);
  env.hook.destroyed();
});

test("hook reuses an existing MathJax engine, awaiting its startup", async t => {
  const env = await hook(t);
  const startup = Promise.withResolvers();
  window.MathJax = { typesetPromise() {}, startup: { promise: startup.promise } };
  env.el.dataset.figure = '{"layout":{"title":"$x$"}}';
  env.hook.mounted();
  await nextTurn();
  assert.equal(env.scripts.length, 0);
  assert.equal(env.calls.some(([name]) => name === "newPlot"), false);
  startup.resolve();
  await nextTurn();
  assert.equal(env.calls.filter(([name]) => name === "newPlot").length, 1);
  env.hook.destroyed();
});

test("destroying a hook while Plotly loads prevents a late render", async t => {
  const env = await hook(t);
  delete window.Plotly;
  env.hook.mounted();
  env.hook.destroyed();
  window.Plotly = env.plotly;
  env.scripts[0].onload();
  await nextTurn();
  assert.equal(env.calls.filter(([name]) => name === "newPlot").length, 0);
  assert.equal(env.observers.length, 0);
});

test("an update supersedes a mount waiting for Plotly", async t => {
  const env = await hook(t);
  delete window.Plotly;
  env.hook.mounted();
  env.el.dataset.figure = '{"data":[{"type":"scatter","x":[9]}]}';
  env.hook.updated();
  window.Plotly = env.plotly;
  env.scripts[0].onload();
  await nextTurn();
  const renders = env.calls.filter(([name]) => ["newPlot", "react"].includes(name));
  assert.equal(renders.length, 1);
  assert.deepEqual(renders[0][2], [{ type: "scatter", x: [9] }]);
  assert.equal(env.observers.length, 1);
  env.hook.destroyed();
});

test("hook falls back to the mirror when the primary source fails and warns once", async t => {
  const env = await hook(t);
  const warn = t.mock.method(console, "warn", () => {});
  delete window.Plotly;
  env.hook.mounted();
  assert.equal(env.scripts[0].src, "primary");
  env.scripts[0].onerror();
  assert.equal(env.scripts[1].src, "mirror");
  window.Plotly = env.plotly;
  env.scripts[1].onload();
  await nextTurn();
  assert.equal(env.calls.filter(([name]) => name === "newPlot").length, 1);
  assert.equal(warn.mock.callCount(), 1);
  assert.match(warn.mock.calls[0].arguments[0], /fell back to mirror/);
  env.hook.destroyed();
});

test("hook retries loading on the next render after every source failed", async t => {
  const env = await hook(t);
  delete window.Plotly;
  const failed = env.hook.mounted();
  env.scripts[0].onerror();
  env.scripts[1].onerror();
  await assert.rejects(failed, /all plotly.js sources failed/);
  assert.equal(env.calls.filter(([name]) => name === "newPlot").length, 0);

  env.hook.updated();
  assert.equal(env.scripts.length, 3);
  assert.equal(env.scripts[2].src, "primary");
  window.Plotly = env.plotly;
  env.scripts[2].onload();
  await nextTurn();
  assert.equal(env.calls.filter(([name]) => ["newPlot", "react"].includes(name)).length, 1);
  env.hook.destroyed();
});

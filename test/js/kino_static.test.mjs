import test from "node:test";
import assert from "node:assert/strict";
import { browser, freshModule, nextTurn, mathJaxScriptLoaded } from "./browser_helpers.mjs";

function payload(figure) {
  return JSON.stringify({ figureJson: JSON.stringify(figure), plotlyUrls: [], version: "4.1.2" });
}

test("Kino static plots the figure with its config", async t => {
  const env = browser(t);
  const { init } = await freshModule("../../priv/plotly_js/plotly_static.js");
  const figure = { data: [{ type: "quiver", x: [0], y: [0], u: [1], v: [1] }], config: { showSendToCloud: false } };
  init({ root: env.el }, payload(figure));
  await nextTurn();
  const [call] = env.calls.filter(([name]) => name === "newPlot");
  assert.deepEqual(call[2], figure.data);
  assert.deepEqual(call[4], { showSendToCloud: false });
});

test("Kino static loads MathJax 4 before plotting a figure with math", async t => {
  const env = browser(t);
  const { init } = await freshModule("../../priv/plotly_js/plotly_static.js");
  init({ root: env.el }, payload({ layout: { title: { text: "$x^2$" } } }));
  await nextTurn();
  assert.equal(env.scripts.at(-1).src, "https://cdn.jsdelivr.net/npm/mathjax@4/tex-svg.js");
  assert.equal(env.calls.some(([name]) => name === "newPlot"), false);
  let startupDone;
  mathJaxScriptLoaded(env.scripts.at(-1), { promise: new Promise(r => { startupDone = r; }) });
  startupDone();
  await nextTurn();
  await nextTurn();
  assert.equal(env.calls.filter(([name]) => name === "newPlot").length, 1);
});

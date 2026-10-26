import test from "node:test";
import assert from "node:assert/strict";
import { browser, freshModule, nextTurn, mathJaxScriptLoaded } from "./browser_helpers.mjs";

for (const path of ["../../priv/plotly_js/plotly_loader.js", "../../priv/static/plotly_hook.js"]) {
  test(`${path}: MathJax callers share script and startup readiness`, async t => {
    const env = browser(t);
    const loader = await freshModule(path);
    assert.equal(typeof loader.loadMathJax, "function");
    const startup = Promise.withResolvers();
    const completed = [];
    const first = loader.loadMathJax().then(() => completed.push(1));
    const second = loader.loadMathJax().then(() => completed.push(2));
    await nextTurn();
    assert.equal(env.scripts.length, 1);
    assert.equal(env.scripts[0].src, "https://cdn.jsdelivr.net/npm/mathjax@4/tex-svg.js");
    assert.deepEqual(completed, []);
    mathJaxScriptLoaded(env.scripts[0], startup);
    await nextTurn();
    assert.deepEqual(completed, []);
    startup.resolve();
    await Promise.all([first, second]);
    assert.deepEqual(completed, [1, 2]);
  });
}

test("Plotly loader falls back to the mirror and warns once", async t => {
  const env = browser(t);
  delete window.Plotly;
  const { loadPlotly } = await freshModule("../../priv/plotly_js/plotly_loader.js");
  const warnings = [];
  t.mock.method(console, "warn", value => warnings.push(value));
  const loading = loadPlotly(["primary", "mirror", "bundle"]);
  assert.equal(env.scripts[0].src, "primary");
  env.scripts[0].onerror();
  assert.equal(env.scripts[1].src, "mirror");
  window.Plotly = env.plotly;
  env.scripts[1].onload();
  await loading;
  assert.equal(warnings.length, 1);
  assert.match(warnings[0], /mirror/);
});

test("Plotly loader rejects after every source fails", async t => {
  const env = browser(t);
  delete window.Plotly;
  const { loadPlotly } = await freshModule("../../priv/plotly_js/plotly_loader.js");
  const loading = loadPlotly(["primary", "mirror", "bundle"]);
  const rejection = assert.rejects(loading, /all plotly.js sources failed/);
  for (let i = 0; i < 3; i++) env.scripts[i].onerror();
  await rejection;
  assert.deepEqual(env.scripts.map(script => script.src), ["primary", "mirror", "bundle"]);
});

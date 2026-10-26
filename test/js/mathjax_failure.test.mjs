import test from "node:test";
import assert from "node:assert/strict";
import { browser, freshModule, mathJaxScriptLoaded } from "./browser_helpers.mjs";

for (const path of ["../../priv/plotly_js/plotly_loader.js", "../../priv/static/plotly_hook.js"]) {
  test(`${path}: an existing engine's rejected startup does not block charts`, async t => {
    browser(t);
    const { loadMathJax } = await freshModule(path);
    const warnings = [];
    t.mock.method(console, "warn", message => warnings.push(message));
    window.MathJax = {
      typesetPromise() {},
      startup: { promise: Promise.reject(new Error("MathJax startup failed")) }
    };

    await assert.doesNotReject(loadMathJax(), "existing MathJax startup failure must remain optional");
    assert.ok(warnings.some(message => /MathJax startup failed/.test(message)));
  });

  test(`${path}: a subsequent call tolerates a previously rejected startup`, async t => {
    const env = browser(t);
    const { loadMathJax } = await freshModule(path);
    const warnings = [];
    t.mock.method(console, "warn", message => warnings.push(message));

    const first = loadMathJax();
    mathJaxScriptLoaded(env.scripts[0], {
      promise: Promise.reject(new Error("MathJax startup failed"))
    });
    await assert.doesNotReject(first, "initial startup failure must not block charts");
    assert.equal(warnings.length, 1);

    await assert.doesNotReject(loadMathJax(), "a failed startup must not block a later chart");
  });

  test(`${path}: MathJax failure warns without blocking charts and permits retry`, async t => {
    const env = browser(t);
    const { loadMathJax } = await freshModule(path);
    const warnings = [];
    t.mock.method(console, "warn", message => warnings.push(message));

    const first = loadMathJax();
    const second = loadMathJax();
    const tolerated = assert.doesNotReject(Promise.all([first, second]), "optional MathJax failure must not block either concurrent chart");
    assert.equal(env.scripts.length, 1);
    env.scripts[0].onerror();
    await tolerated;
    assert.equal(warnings.length, 1);
    assert.match(warnings[0], /MathJax/);

    const retry = loadMathJax();
    assert.equal(env.scripts.length, 2, "a failed load must not poison subsequent attempts");
    mathJaxScriptLoaded(env.scripts[1], { promise: Promise.resolve() });
    await retry;
    assert.equal(warnings.length, 1, "successful retry does not add a failure warning");
  });
}

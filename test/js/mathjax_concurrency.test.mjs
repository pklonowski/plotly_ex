import test from "node:test";
import assert from "node:assert/strict";
import { setImmediate as nextTurn } from "node:timers/promises";
import { loadMathJax } from "../../priv/plotly_js/plotly_loader.js";

test("concurrent MathJax callers both wait for script load and startup", async () => {
  const previousWindow = globalThis.window;
  const previousDocument = globalThis.document;
  const scripts = [];
  const startup = Promise.withResolvers();

  globalThis.window = {};
  globalThis.document = {
    querySelector(selector) {
      return scripts.find((script) => selector === `script[src="${script.src}"]`) ?? null;
    },
    createElement() { return {}; },
    head: { appendChild(script) { scripts.push(script); } }
  };

  const completed = [];
  const first = loadMathJax().then(() => completed.push("first"));
  const second = loadMathJax().then(() => completed.push("second"));

  function finishScriptLoad() {
    window.MathJax = {
      typesetPromise() {},
      startup: { promise: startup.promise }
    };
    scripts[0].onload();
  }

  try {
    assert.equal(scripts.length, 1, "concurrent callers must share one script");
    // Advance an event-loop turn to flush promise continuations without a timed sleep.
    await nextTurn();
    assert.deepEqual(completed, [], "neither caller may finish before the script loads");

    finishScriptLoad();
    await nextTurn();
    assert.deepEqual(completed, [], "neither caller may finish before MathJax startup");

    startup.resolve();
    await Promise.all([first, second]);
    assert.deepEqual(completed.sort(), ["first", "second"]);
  } finally {
    finishScriptLoad();
    startup.resolve();
    await Promise.allSettled([first, second]);
    if (previousWindow === undefined) delete globalThis.window;
    else globalThis.window = previousWindow;
    if (previousDocument === undefined) delete globalThis.document;
    else globalThis.document = previousDocument;
  }
});

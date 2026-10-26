import { setImmediate as nextTurn } from "node:timers/promises";
export { nextTurn };

export function browser(t) {
  const previous = new Map(["window", "document", "Plotly", "ResizeObserver"].map(key => [key, Object.getOwnPropertyDescriptor(globalThis, key)]));
  const scripts = [];
  const calls = [];
  const observers = [];
  const handlers = new Map();
  const el = {
    dataset: { figure: JSON.stringify({ data: [{ type: "scatter", x: [1], y: [2] }] }), plotlyUrls: '["primary", "mirror"]' },
    data: [{ type: "scatter" }],
    on(name, fn) { const list = handlers.get(name) || []; list.push(fn); handlers.set(name, list); },
    removeListener(name, fn) { handlers.set(name, (handlers.get(name) || []).filter(value => value !== fn)); }
  };
  const plotly = {
    newPlot: async (...args) => { calls.push(["newPlot", ...args]); },
    react: async (...args) => { calls.push(["react", ...args]); },
    purge: (...args) => { calls.push(["purge", ...args]); },
    Plots: { resize: (...args) => { calls.push(["resize", ...args]); } }
  };
  globalThis.window = { Plotly: plotly };
  globalThis.Plotly = plotly;
  globalThis.document = {
    querySelector: selector => scripts.find(script => selector === `script[src="${script.src}"]`) || null,
    createElement: () => ({}),
    head: { appendChild(script) { scripts.push(script); calls.push(["script", script.src]); } }
  };
  globalThis.ResizeObserver = class {
    constructor(callback) { this.callback = callback; observers.push(this); }
    observe(target) { this.target = target; }
    disconnect() { this.disconnected = true; }
  };
  t.after(() => {
    for (const [key, descriptor] of previous) {
      if (descriptor) Object.defineProperty(globalThis, key, descriptor);
      else delete globalThis[key];
    }
  });
  return { scripts, calls, el, handlers, observers, plotly };
}

let importId = 0;
export function freshModule(path) {
  return import(new URL(`${path}?test=${++importId}`, import.meta.url));
}

export function mathJaxScriptLoaded(script, startup) {
  window.MathJax = { typesetPromise() {}, startup: { promise: startup.promise } };
  script.onload();
}

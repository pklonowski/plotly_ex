/**
 * PlotlyChart LiveView hook.
 *
 * Usage in app.js:
 *   import { PlotlyChart } from "../../deps/plotly_ex/priv/static/plotly_hook.js"
 *   let liveSocket = new LiveSocket("/live", Socket, { hooks: { PlotlyChart } })
 *
 * Plotly events (plotly_click, plotly_hover, plotly_unhover, plotly_relayout, plotly_selected) are
 * forwarded to LiveView as handle_event("plotly_event", %{"type" => ..., "data" => ...}).
 *
 * Performance note: for large datasets (>10k points), use push_event/3 instead
 * of the data-figure attribute to avoid large LiveView diffs on every update.
 */

let _plotlyPromise = null;

function ensurePlotly(el) {
  if (window.Plotly) return Promise.resolve();
  if (_plotlyPromise) return _plotlyPromise;
  const urls = JSON.parse(el.dataset.plotlyUrls || "[]");
  _plotlyPromise = new Promise((resolve, reject) => {
    const tryLoad = (i) => {
      if (window.Plotly) return resolve();
      if (i >= urls.length) { _plotlyPromise = null; return reject(new Error("plotly_ex: all plotly.js sources failed")); }
      const s = document.createElement("script");
      s.src = urls[i];
      s.onload = () => { if (i > 0) console.warn("plotly_ex: primary plotly.js source was unreachable; fell back to " + urls[i] + ". The bundled copy is an offline fallback vendored with plotly_ex."); resolve(); };
      s.onerror = () => tryLoad(i + 1);
      document.head.appendChild(s);
    };
    tryLoad(0);
  });
  return _plotlyPromise;
}

export const PlotlyChart = {
  mounted() {
    this._destroyed = false;
    return this._render(true);
  },

  updated() {
    return this._render(false);
  },

  async _render(initial) {
    const token = this._renderToken = (this._renderToken || 0) + 1;
    const figureJson = this.el.dataset.figure;
    await ensurePlotly(this.el);
    if (this._destroyed || this._renderToken !== token) return;
    if (figureJson.includes("$")) await loadMathJax();
    if (this._destroyed || this._renderToken !== token) return;

    this._unregisterPlotlyEvents();
    const fig = resolveRawJS(JSON.parse(figureJson));
    const currentType = (this.el.data || [])[0]?.type;
    const newType = (fig.data || [])[0]?.type;
    if (initial || currentType !== newType) {
      if (!initial) Plotly.purge(this.el);
      await Plotly.newPlot(this.el, fig.data || [], fig.layout || {}, fig.config || {});
    } else {
      await Plotly.react(this.el, fig.data || [], fig.layout || {}, fig.config || {});
    }
    if (this._destroyed || this._renderToken !== token) return;
    Plotly.Plots.resize(this.el);
    this._registerPlotlyEvents();
    if (!this._resizeObserver) {
      this._resizeObserver = new ResizeObserver(() => Plotly.Plots.resize(this.el));
      this._resizeObserver.observe(this.el);
    }
  },

  destroyed() {
    this._destroyed = true;
    this._renderToken = (this._renderToken || 0) + 1;
    this._unregisterPlotlyEvents();
    if (this._resizeObserver) this._resizeObserver.disconnect();
    if (window.Plotly) Plotly.purge(this.el);
  },

  _registerPlotlyEvents() {
    this._unregisterPlotlyEvents();
    const hook = this;
    const events = ["plotly_click", "plotly_hover", "plotly_unhover", "plotly_relayout", "plotly_selected"];
    this._plotlyHandlers = {};
    events.forEach(function(eventName) {
      const handler = function(data) {
        hook.pushEvent("plotly_event", {
          type: eventName,
          data: serializePlotlyEvent(data, eventName)
        });
      };
      hook._plotlyHandlers[eventName] = handler;
      hook.el.on(eventName, handler);
    });
  },

  _unregisterPlotlyEvents() {
    if (!this._plotlyHandlers) return;
    const el = this.el;
    Object.entries(this._plotlyHandlers).forEach(function([eventName, handler]) {
      if (typeof el.removeListener === 'function') el.removeListener(eventName, handler);
    });
    this._plotlyHandlers = {};
  }
};

function resolveRawJS(value) {
  if (value === null || value === undefined) return value;
  if (Array.isArray(value)) return value.map(resolveRawJS);
  if (typeof value === 'object') {
    if ('__rawjs__' in value) {
      try { return (new Function('return (' + value['__rawjs__'] + ')'))(); } catch(e) { return undefined; }
    }
    const out = {};
    for (const [k, v] of Object.entries(value)) out[k] = resolveRawJS(v);
    return out;
  }
  return value;
}

const POINT_EVENTS = ["plotly_click", "plotly_hover", "plotly_unhover", "plotly_selected"];

// Keep this contract identical in the LiveView and Kino adapters (shared test fixtures).
// Cursor pixels belong to the event; pixels inside points are the point centres.
export function serializePlotlyEvent(data, eventName) {
  if (Array.isArray(data?.points) || POINT_EVENTS.includes(eventName)) {
    return {
      points: (data?.points ?? []).map(p => ({
        x: p.x ?? null, y: p.y ?? null, z: p.z ?? null,
        curveNumber: p.curveNumber ?? null,
        pointNumber: p.pointNumber ?? null,
        pointIndex: p.pointIndex ?? null,
        text: p.text ?? null,
        customdata: p.customdata ?? null,
        name: p.data?.name ?? null,
        bbox: p.bbox ?? null,
        xPixel: p.xPixel ?? null,
        yPixel: p.yPixel ?? null
      })),
      xvals: data?.xvals ?? null,
      yvals: data?.yvals ?? null,
      xPixel: data?.xPixel ?? null,
      yPixel: data?.yPixel ?? null
    };
  }
  if (data == null) return null;
  try {
    return JSON.parse(JSON.stringify(data));
  } catch (_) {
    return { error: "unserializable" };
  }
}

let mathJaxPromise = null;

// Each chart awaits the same script load AND startup, including concurrent callers.
export async function loadMathJax() {
  if (mathJaxPromise) return mathJaxPromise;
  mathJaxPromise = (async () => {
    if (window.MathJax?.typesetPromise) {
      await window.MathJax.startup?.promise;
      return;
    }
    window.MathJax = {
      tex: { inlineMath: [["$", "$"]] },
      svg: { fontCache: "local" },
      startup: { typeset: false }
    };
    await new Promise((resolve, reject) => {
      const script = document.createElement("script");
      script.src = "https://cdn.jsdelivr.net/npm/mathjax@4/tex-svg.js";
      script.onload = resolve;
      script.onerror = () => {
        script.remove?.();
        reject(new Error("plotly_ex: MathJax could not be loaded"));
      };
      document.head.appendChild(script);
    });
    await window.MathJax.startup?.promise;
  })().catch((error) => {
    // MathJax is optional: every waiting chart can still render plain text.
    console.warn(error.message);
  }).finally(() => {
    mathJaxPromise = null;
  });
  return mathJaxPromise;
}

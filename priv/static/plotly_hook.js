/**
 * PlotlyChart LiveView hook.
 *
 * Usage in app.js:
 *   import { PlotlyChart } from "../../deps/plotly_ex/priv/static/plotly_hook.js"
 *   let liveSocket = new LiveSocket("/live", Socket, { hooks: { PlotlyChart } })
 *
 * Plotly events (plotly_click, plotly_hover, plotly_relayout, plotly_selected) are
 * forwarded to LiveView as handle_event("plotly_event", %{"type" => ..., "data" => ...}).
 *
 * Performance note: for large datasets (>10k points), use push_event/3 instead
 * of the data-figure attribute to avoid large LiveView diffs on every update.
 */
export const PlotlyChart = {
  mounted() {
    this._renderToken = (this._renderToken || 0) + 1;
    const token = this._renderToken;
    const fig = resolveRawJS(JSON.parse(this.el.dataset.figure));
    Plotly.newPlot(this.el, fig.data || [], fig.layout || {}, fig.config || {}).then(() => {
      if (this._renderToken !== token) return;
      Plotly.Plots.resize(this.el);
      this._registerPlotlyEvents();
    });
    this._resizeObserver = new ResizeObserver(() => Plotly.Plots.resize(this.el));
    this._resizeObserver.observe(this.el);
  },

  updated() {
    this._renderToken = (this._renderToken || 0) + 1;
    const token = this._renderToken;
    this._unregisterPlotlyEvents();
    const fig = resolveRawJS(JSON.parse(this.el.dataset.figure));
    const currentType = (this.el.data || [])[0]?.type;
    const newType = (fig.data || [])[0]?.type;
    let renderPromise;
    if (currentType !== newType) {
      Plotly.purge(this.el);
      renderPromise = Plotly.newPlot(this.el, fig.data || [], fig.layout || {}, fig.config || {});
    } else {
      renderPromise = Plotly.react(this.el, fig.data || [], fig.layout || {}, fig.config || {});
    }
    renderPromise.then(() => {
      if (this._renderToken !== token) return;
      Plotly.Plots.resize(this.el);
      this._registerPlotlyEvents();
    });
  },

  destroyed() {
    if (this._resizeObserver) this._resizeObserver.disconnect();
    Plotly.purge(this.el);
  },

  _registerPlotlyEvents() {
    this._unregisterPlotlyEvents();
    const hook = this;
    const events = ["plotly_click", "plotly_hover", "plotly_relayout", "plotly_selected"];
    this._plotlyHandlers = {};
    events.forEach(function(eventName) {
      const handler = function(data) {
        hook.pushEvent("plotly_event", {
          type: eventName,
          data: serializePlotlyEvent(data)
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

function serializePlotlyEvent(data) {
  if (!data) return null;
  if (data.points) {
    return {
      points: data.points.map(function(p) {
        return {
          x: p.x, y: p.y, z: p.z,
          curveNumber: p.curveNumber,
          pointNumber: p.pointNumber,
          pointIndex: p.pointIndex,
          text: p.text,
          customdata: p.customdata,
          name: p.data && p.data.name
        };
      })
    };
  }
  try {
    return JSON.parse(JSON.stringify(data));
  } catch (_) {
    return { error: "unserializable" };
  }
}

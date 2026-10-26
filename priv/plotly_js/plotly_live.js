// priv/plotly_js/plotly_live.js
import { loadPlotly, loadLocale, loadMathJax, resolveRawJS } from "./plotly_loader.js";

export function init(ctx, payloadJson) {
  const { figureJson, plotlyUrls, version } = JSON.parse(payloadJson);

  let plotted = false;
  let eventsRegistered = false;
  const ensureEvents = () => {
    if (eventsRegistered) return;
    registerPlotlyEvents(ctx);
    eventsRegistered = true;
  };

  // Updates must wait for initialization and for earlier renders to finish.
  // A failed initial render is reported once; a later valid update can still plot.
  const initialized = loadPlotly(plotlyUrls).then(async () => {
    const fig = resolveRawJS(JSON.parse(figureJson));
    await loadLocale(version, fig.config && fig.config.locale);
    if (figureJson.includes("$")) await loadMathJax();
    await Plotly.newPlot(ctx.root, fig.data || [], fig.layout || {}, fig.config || {});
    plotted = true;
    if (fig.frames && fig.frames.length > 0) {
      await Plotly.addFrames(ctx.root, fig.frames);
    }
    ensureEvents();
  }).catch(error => console.warn("plotly_ex: initial render failed", error));

  let rendering = Promise.resolve();
  ctx.handleEvent("update", (newFigureJson) => {
    const update = rendering.then(async () => {
      await initialized;
      const newFig = resolveRawJS(JSON.parse(newFigureJson));
      await loadLocale(version, newFig.config && newFig.config.locale);
      if (newFigureJson.includes("$")) await loadMathJax();
      const args = [ctx.root, newFig.data || [], newFig.layout || {}, newFig.config || {}];
      await (plotted ? Plotly.react(...args) : Plotly.newPlot(...args));
      plotted = true;
      ensureEvents();
    });
    // Report this update's failure without preventing later corrected figures.
    rendering = update.catch(error => console.warn("plotly_ex: live update failed", error));
    return update;
  });
}

function registerPlotlyEvents(ctx) {
  const events = ["plotly_click", "plotly_hover", "plotly_unhover", "plotly_relayout", "plotly_selected"];
  events.forEach(function (eventName) {
    ctx.root.on(eventName, function (data) {
      ctx.pushEvent("plotly_event", JSON.stringify({
        type: eventName,
        data: serializePlotlyEvent(data, eventName)
      }));
    });
  });
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

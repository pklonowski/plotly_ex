// priv/plotly_js/plotly_static.js
import { loadPlotly, loadLocale, loadMathJax, resolveRawJS } from "./plotly_loader.js";

export function init(ctx, payloadJson) {
  const { figureJson, plotlyUrls, version } = JSON.parse(payloadJson);
  const fig = JSON.parse(figureJson);

  loadPlotly(plotlyUrls).then(async () => {
    const resolved = resolveRawJS(fig);
    await loadLocale(version, resolved.config && resolved.config.locale);
    if (figureJson.includes("$")) await loadMathJax();
    Plotly.newPlot(ctx.root, resolved.data || [], resolved.layout || {}, resolved.config || {});
  });
}

# Changelog

## v0.1.0 (2026-02-23)

First release.

### Added
- Express API: `scatter/2`, `bar/2`, `line/2`, `histogram/2`, `box/2`, `violin/2`,
  `candlestick/2`, `ohlc/2`, `waterfall/2`, `sunburst/2`, `treemap/2`,
  `scatter3d/2`, `scattergeo/2`, `choropleth/2`, `scattermap/2`,
  `funnel/2`, `scatterpolar/2`, `barpolar/2`, `histogram2d/2`, `indicator/2`
- Fluent builder: `Plotly.Figure` with `new/1`, `add_trace/2`, `update_layout/2`,
  `merge/2`, `to_json/1`
- Livebook integration via Kino: `PlotlyLive` (reactive), `PlotlyStatic` (static),
  `SmartCell` (no-code chart builder with multi-layer support)
- Phoenix LiveView integration via `Plotly.Phoenix.Component`
- Phoenix LiveView static component: `Plotly.Phoenix.Component.static_plot/2`
- `Plotly.RawJS` for embedding raw JavaScript values in config
- Auto-rendering: `Kino.Render` protocol for `Plotly.Figure`

### Documentation
- Expanded README with full Livebook, SmartCell, and Phoenix LiveView guides
- Added notebook usage table with per-notebook coverage descriptions
- Added `phx_ex/` example project instructions
- Added License section

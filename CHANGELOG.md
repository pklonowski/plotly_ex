# Changelog

## v0.3.0 (2026-10-26)

This release includes the unpublished 0.2.0 changes below. The previous Hex
release was 0.1.0; use the README migration guide when upgrading.

### Breaking

- Target plotly.js **4.1.2**. Migrate `Scattermapbox` / `Choroplethmapbox` /
  `Densitymapbox` to the equivalent `*map` traces and `layout.mapbox` to `layout.map`.
  Deprecated constructors now raise actionable migration errors.
- Regenerated structs reject removed top-level `stream`, `*src` and
  `layout.hidesources` fields. `Choroplethmap` opacity belongs in `marker.opacity`.
- Warn on removed Chart Studio config keys and `mapboxAccessToken`.
- Adopt upstream color parsing and axis defaults; map traces require WebGL2 and
  MathJax 2 is no longer supported. See the README migration guide for the full list.

### Added

- Quiver vector fields through `Plotly.Quiver`, `Plotly.Express.quiver/2`,
  `Plotly.quiver/2`, color grouping, and smart-cell X/Y/U/V selectors.
- Shared Kino/LiveView event payloads with cursor and point pixels, `bbox`,
  `xvals`/`yvals`, and `plotly_unhover`; missing values consistently serialize as null.
- MathJax 4 loading for Kino and on-demand loading in the LiveView hook.
- Schema support for Sankey direction/order, geo scale bounds and legend group
  double-click behavior. Notebook examples cover JSON export, modern CSS colors,
  map migration, quiver and anywhere events.

### Changed

- Disable Plotly Cloud upload by default on all render paths, preserving explicit
  `showSendToCloud` values. `Figure.to_json/1` remains faithful to the original figure.
- Version the Phoenix bundled URL to invalidate previously cached JavaScript on upgrade.
- Serialize Kino live renders so startup or a slow earlier render cannot overwrite a newer update.
- Regeneration removes obsolete generated trace files while retaining handwritten files.
- Update Phoenix demos, Livebook notebooks, migration documentation and regression tests.
- Refresh locked development dependencies, including upstream security patches.
- Stage only tracked working-tree files for public releases, omit private tooling,
  and rewrite all notebook dependencies for Hex installation.

### Fixed

- Normalize bare-string 3D scene axis titles so their text renders correctly.
- Share concurrent MathJax loading and tolerate startup failures without blocking charts.
- Fix the Relayout Button notebook's light-theme action (renamed Default to Light) and make Reset restore both the light appearance and automatic axis ranges.
- Preserve empty data arrays as `[]`, while keeping empty figure layout/config options as objects.
- Accept atom- and string-keyed Express rows and selectors, including grouped quiver and Explorer color selectors.
- Resolve bundled named templates (string or atom) consistently across all renderers; preserve inline templates and faithful figure JSON. Combine them with `+` (e.g. `"plotly_dark+presentation"`, deep-merged left to right). Unknown names log a warning and render without a template instead of crashing.
- Recover Kino live charts after an initial render failure and attach event listeners once after successful plotting.

### Upstream fixes

The bundled upgrade includes the fixes in
[plotly.js 4.0.0–4.1.2](https://github.com/plotly/plotly.js/blob/v4.1.2/CHANGELOG.md),
including map selection, font-load redraw, hover handling and responsive resizing.

## v0.2.0 (2026-06-17, unpublished)

### Changed
- Upgraded the bundled/loaded plotly.js to **3.6.0** (from 2.35.2 / 3.3.1).
- Bumped the development toolchain to **Elixir 1.20.1 / OTP 29** during development.
- Refreshed dependencies to their latest compatible releases: `phoenix_live_view`
  1.1 → 1.2, `kino` 0.18 → 0.19, `phoenix` 1.8.3 → 1.8.8, `ex_doc` 0.40.3, `jason`
  1.4.5, `usage_rules` 1.2.6. Library version constraints remain wide for downstream
  compatibility.

### Added
- Automatic plotly.js loading with a **CDN → jsdelivr → bundled** fallback chain. Each
  fallback emits a helpful warning explaining what happened and how to silence it. Both the
  LiveView hook and `static_plot/2` self-load plotly.js when it isn't already present.
- `Plotly.PlotlyJS` — single source of truth for the plotly.js version and ordered source
  URLs (CDN, jsdelivr mirror, vendored offline bundle).
- `Plotly.Phoenix.Plug` — serves the vendored offline plotly.js bundle; enable the bundled
  fallback with `forward "/plotly_ex", Plotly.Phoenix.Plug` in your router.

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

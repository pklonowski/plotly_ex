# plotly_ex

[![Hex.pm](https://img.shields.io/hexpm/v/plotly_ex.svg)](https://hex.pm/packages/plotly_ex)
[![HexDocs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/plotly_ex)
[![License](https://img.shields.io/hexpm/l/plotly_ex.svg)](https://github.com/pklonowski/plotly_ex/blob/main/LICENSE)

Interactive [Plotly.js](https://plotly.com/javascript/) charts for Elixir — works in
[Livebook](https://livebook.dev) via Kino and in Phoenix LiveView.

`plotly_ex` is an Elixir binding for [Plotly](https://plotly.com/) — a leading open-source
charting library with support for 48 interactive trace types including statistical, financial,
scientific, geographic, and 3D visualisations. Visit [plotly.com](https://plotly.com/) to
explore the full range of chart types and configuration options.

This library was heavily inspired by [`VegaLite`](https://hex.pm/packages/vega_lite), the
Elixir implementation of the [Vega-Lite](https://vega.github.io/vega-lite/) grammar. Like
`VegaLite`, `plotly_ex` provides both a concise Express API for rapid chart creation and a
fluent builder API for fine-grained control — with first-class Livebook and Phoenix LiveView
integration courtesy of [Kino](https://hex.pm/packages/kino).

- **Express API** — one-call chart building from lists-of-maps or Explorer DataFrames
- **Fluent builder** — compose traces and layouts step-by-step
- **SmartCell** — no-code chart builder in Livebook
- **Phoenix LiveView component** with live reactive updates
- **48 Plotly.js trace types** (scatter, bar, heatmap, 3D, maps, financial, …)
- **Live updates** via `PlotlyLive.push/2`
- **Browser event subscriptions** (click, hover, zoom)

---

## Installation

Version **0.3.0** targets **Plotly.js 4.1.2** and requires **Elixir 1.15 or later**.
Kino, Explorer, and Phoenix integrations are optional; install the dependencies
for the integrations you use. Browser map traces require WebGL2.

Upgrading from Hex's 0.1.0 release? Read the [v4 migration guide](#upgrading-to-plotlyjs-v4-030)
below. Version 0.2.0 was an unpublished development milestone; 0.3.0 includes
its automatic CDN fallback and offline bundle support.

**In a Livebook notebook** (`Mix.install`):

```elixir
Mix.install([
  {:plotly_ex, "~> 0.3"},
  {:kino, "~> 0.14"},
  # optional — pass Explorer DataFrames to Express functions:
  {:explorer, "~> 0.11"}
])
```

**In a Mix project** (`mix.exs`):

```elixir
def deps do
  [
    {:plotly_ex, "~> 0.3"},
    # Optional integrations:
    {:kino, "~> 0.14", optional: true},            # Livebook
    {:explorer, "~> 0.11", optional: true},         # Explorer DataFrames
    {:phoenix_live_view, "~> 1.0", optional: true}  # Phoenix LiveView
  ]
end
```

---

## Livebook

### Express API

One call to chart from a list of maps:

```elixir
data = [
  %{"month" => "Jan", "sales" => 42},
  %{"month" => "Feb", "sales" => 55},
  %{"month" => "Mar", "sales" => 38}
]
Plotly.bar(data, x: "month", y: "sales", title: "Monthly Sales")
|> Plotly.show()
```

Or from an Explorer DataFrame:

```elixir
df = Explorer.DataFrame.new(x: [1, 2, 3], y: [10, 20, 15])
Plotly.scatter(df, x: "x", y: "y", title: "From DataFrame")
|> Plotly.show()
```

Express rows may use atom or string keys, and column selectors may use either.
An exact key wins if a row contains both forms; `nil` and `false` values are
preserved. Color grouping follows the same rule, including Explorer atom selectors.

### Named templates

Use `template: "plotly_dark"` (or the atom `:plotly_dark`) in Express, or set `layout.template` in a figure.
The library bundles the official Plotly.py templates: `ggplot2`, `gridon`,
`plotly`, `plotly_dark`, `plotly_white`, `presentation`, `seaborn`, `simple_white`,
`xgridoff`, and `ygridoff`. `none` supplies an empty template. These work in
Kino live/static and Phoenix LiveView/static rendering without a JavaScript registry.

```elixir
Plotly.scatter([%{x: 1, y: 2}, %{x: 2, y: 5}],
  x: :x, y: :y, template: "plotly_dark"
)
|> Plotly.show()
```

Inline template maps remain supported, and explicit layout values override their
defaults. Combine templates with `+`, e.g. `template: "plotly_dark+presentation"`:
they deep-merge left to right, later templates winning. An unknown name logs a
warning and the chart renders without that template (no crash). `Figure.to_json/1`
retains the name; `Figure.to_render_json/1` expands it into a concrete template.

### Fluent Builder

For full control over trace properties:

Empty lists serialize as JSON arrays, including nested data such as `x: []`.
Nonempty keyword lists become objects; use `%{}` for an empty object. The
figure's top-level layout/config also accept `[]` as empty keyword options.

```elixir
alias Plotly.{Figure, Scatter}

Figure.new()
|> Figure.add_trace(Scatter.new(x: [1, 2, 3], y: [4, 5, 6], name: "A"))
|> Figure.add_trace(Scatter.new(x: [1, 2, 3], y: [6, 5, 4], name: "B"))
|> Figure.update_layout(title: "Two Traces", width: 700)
|> Plotly.show()
```

Nested trace options (marker, line, etc.) accept plain maps:

```elixir
Scatter.new(
  x: [1, 2, 3], y: [4, 5, 6],
  marker: %{color: "red", size: 10},
  line: %{dash: "dot"}
)
```

### SmartCell (no-code chart builder)

The SmartCell is auto-registered when `kino` is present — no setup needed.

1. In Livebook, click **+ Smart cell** → choose **Plotly Chart**
2. Pick a variable (DataFrame or list of maps), chart type, and column axes
3. Click **+ Add layer** to overlay multiple traces
4. Generated code can be copied and edited freely

Chart types: scatter, bar, line, histogram, box, violin, pie, and **quiver**.
Quiver requires X/Y positions and U/V vector components; Color by creates one
trace per group.

### Multi-Trace / Layering

`Figure.merge/2` combines traces from two figures while preserving the first figure's layout:

```elixir
Plotly.scatter(df, x: "date", y: "price")
|> Plotly.Figure.merge(Plotly.bar(df, x: "date", y: "volume"))
|> Plotly.show()
```

### Live Updates & Events

`PlotlyLive` lets you push updates to an already-displayed chart and subscribe to browser events:

```elixir
chart = Plotly.Kino.PlotlyLive.new(initial_figure)

# Push a new figure without re-evaluating the cell:
Plotly.Kino.PlotlyLive.push(chart, updated_figure)

# Subscribe to browser events with a tag:
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events)

receive do
  {:chart_events, %{"type" => "plotly_click", "data" => data}} ->
    IO.inspect(data["points"])
end
```

Filter to a specific event type:

```elixir
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :click)
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :hover)
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :unhover)
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :relayout)
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :selected)
```

---

## Phoenix

### Static Embed (no LiveView)

For controller-rendered (dead) views, use `static_plot/2` — no hook registration needed.

**1. (Optional) Add Plotly.js to your layout** (`lib/your_app_web/components/layouts/app.html.heex`):

The script tag is **optional** — `static_plot/2` self-loads Plotly.js via the
[loading & fallback chain](#plotlyjs-loading--fallback). Add a tag only if you want to
pin/host a specific copy yourself:

```html
<script src="https://cdn.plot.ly/plotly-4.1.2.min.js"></script>
```

**2. Build the figure in your controller:**

```elixir
def index(conn, _params) do
  monthly = [
    %{"month" => "Jan", "sales" => 42},
    %{"month" => "Feb", "sales" => 55},
    %{"month" => "Mar", "sales" => 61},
    %{"month" => "Apr", "sales" => 48},
    %{"month" => "May", "sales" => 73}
  ]
  figure = Plotly.bar(monthly, x: "month", y: "sales", title: "Monthly Sales")
  render(conn, :index, figure: figure)
end
```

**3. Embed in your template** (`lib/your_app_web/controllers/chart_html/index.html.heex`):

```heex
<%= Plotly.Phoenix.Component.static_plot(@figure, id: "my-chart") %>
```

`static_plot/2` returns `{:safe, html}`. Plotly.js renders the chart on page load.

---

### LiveView

**1. (Optional) Add Plotly.js to your layout** (`lib/your_app_web/components/layouts/app.html.heex`):

The script tag is **optional** — the `PlotlyChart` hook self-loads Plotly.js via the
[loading & fallback chain](#plotlyjs-loading--fallback). Add a tag only if you want to
pin/host a specific copy yourself:

```html
<script src="https://cdn.plot.ly/plotly-4.1.2.min.js"></script>
```

**2. Register the hook** (`assets/js/app.js`):

Import directly from the library (includes event forwarding, render-race protection, and `RawJS` support):

```js
import { PlotlyChart } from "../../deps/plotly_ex/priv/static/plotly_hook.js"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { PlotlyChart }
})
```

**3. Use the component** in your `.heex` template:

```heex
<Plotly.Phoenix.Component.plot id="my-chart" figure={@figure} />
```

**4. Build figures and handle events** in your LiveView:

```elixir
def mount(_params, _session, socket) do
  data = [%{"x" => 1, "y" => 4}, %{"x" => 2, "y" => 7}, %{"x" => 3, "y" => 3}]
  {:ok, assign(socket, figure: Plotly.scatter(data, x: "x", y: "y", title: "Live Chart"))}
end

def handle_event("plotly_event", %{"type" => "plotly_click", "data" => %{"points" => points}}, socket) do
  IO.inspect(points, label: "clicked")
  {:noreply, socket}
end

def handle_event("plotly_event", _event, socket), do: {:noreply, socket}
```

The component calls `Plotly.react` on each assign update — only changed data is re-rendered.

---

### Plotly.js loading & fallback

This library is built and tested against **plotly.js 4.1.2**. Both the LiveView hook and
`static_plot/2` self-load Plotly.js when it isn't already on the page, trying sources in
order and falling back automatically if one is unreachable:

1. **cdn.plot.ly** — `https://cdn.plot.ly/plotly-4.1.2.min.js` (default)
2. **jsdelivr** — `https://cdn.jsdelivr.net/npm/plotly.js@4.1.2/dist/plotly.min.js` (mirror)
3. **bundled** — `/plotly_ex/plotly.min.js?v=4.1.2`, an offline copy vendored with this library

Each fallback emits a `console.warn` explaining what happened and how to silence it (host
plotly.js yourself, or set `source: :bundled`).

To enable the bundled fallback (step 3) in Phoenix, forward a route to the bundled-asset
plug in your router:

```elixir
# lib/your_app_web/router.ex
forward "/plotly_ex", Plotly.Phoenix.Plug
```

The version query invalidates previously cached bundles on upgrade; `bundled_path`
remains the route without the query. In Livebook, the bundled fallback is served
automatically as a content-addressed Kino asset — no router changes are needed.

---

## Notebooks

The `notebooks/` directory contains 16 combined guides, with individual examples
in its topic subdirectories. The public release notebooks install `plotly_ex`
from Hex; development-checkout notebooks use the local source.

**How to open them:**
1. Start Livebook: `livebook server` (or open the Livebook desktop app)
2. Click **Open** → navigate to this repo's `notebooks/` folder
3. Open any `.livemd` file and run the cells

| Notebook | Coverage |
|---|---|
| `01_express.livemd` | Express API: all chart types in one call |
| `02_builder.livemd` | Fluent builder, trace options |
| `03a_fundamentals_config.livemd` | Configuration, Cloud opt-in, JSON download |
| `03b_fundamentals_styling.livemd` | Modern CSS colors, axes, hover templates |
| `03c_fundamentals_shapes.livemd` | Shapes & annotations |
| `04_basic_charts.livemd` | Scatter, bar, pie, table, WebGL |
| `05_statistical.livemd` | Histogram, box, violin, heatmap |
| `06_scientific.livemd` | Quiver vector fields, contour, surface, 3D, polar |
| `07_financial.livemd` | Candlestick, OHLC, waterfall |
| `08_maps.livemd` | Choropleth, scatter geo, tile maps |
| `09_3d.livemd` | 3D scatter, surface, mesh |
| `10_subplots.livemd` | Grid layouts, shared axes |
| `11_custom_controls.livemd` | Buttons, sliders, dropdowns |
| `12_animations.livemd` | Frame-based animations |
| `13_chart_events.livemd` | Click, hover, unhover, anywhere events and pixel coordinates |
| `14_kino_smart_cell.livemd` | SmartCell walkthrough, including quiver X/Y/U/V selectors |

---

## Example Phoenix Project (`phx_ex/`)

`phx_ex/` (in the source repository, not the Hex package) is a standalone Phoenix application demonstrating `plotly_ex` integration in a LiveView.

**Run it:**

```bash
cd phx_ex
mix deps.get
mix assets.build
mix phx.server
# Visit http://localhost:4000
```

Two routes are included:

- `/` — LiveView demo (`lib/phx_ex_web/live/plots_live.ex`): mount figures, update on interaction, handle `plotly_click` events.
- `/static` — Controller demo (`lib/phx_ex_web/controllers/static_plot_controller.ex`): `static_plot/2` in a plain controller with no WebSocket connection.

---

## Configuration

All keys are optional and read at compile time:

```elixir
# config/config.exs
config :plotly_ex, :plotly_js,
  version: "4.1.2",                        # Plotly.js version (must match the vendored bundle)
  source: :cdn,                            # :cdn (default, with jsdelivr → bundled fallback)
                                           # :bundled (use only the local offline copy)
  bundled_path: "/plotly_ex/plotly.min.js" # public URL the Phoenix Plug serves the bundle at
```

- `source: :cdn` (default) loads from cdn.plot.ly, falling back to jsdelivr then the bundled
  copy — see [Plotly.js loading & fallback](#plotlyjs-loading--fallback).
- `source: :bundled` skips the CDNs entirely and serves the vendored offline copy only (no
  fallback warning). Requires `forward "/plotly_ex", Plotly.Phoenix.Plug` in your router.

The compatible plotly.js version is **4.1.2**.

## Upgrading to plotly.js v4 (0.3.0)

This release bundles and targets plotly.js 4.1.2. Upgrade any manually hosted
Plotly script as well as the Elixir dependency; an existing `window.Plotly` is
reused by the loaders. Rebuild Phoenix assets if you copy or bundle the hook.
See the [upstream changelog](https://github.com/plotly/plotly.js/blob/v4.1.2/CHANGELOG.md)
for the complete release history.

### Removed attributes and migration

| Previous API | Replacement or action |
|---|---|
| `Plotly.Scattermapbox`, `Plotly.Choroplethmapbox`, `Plotly.Densitymapbox` | Use `Plotly.Scattermap`, `Plotly.Choroplethmap`, `Plotly.Densitymap`. Old constructors raise a migration error. |
| `layout.mapbox` | Use `layout.map` with the new map traces. The library warns on the removed key; it does not translate it. |
| `config.mapboxAccessToken` | Remove it. The map notebooks demonstrate token-free MapLibre styles. |
| Chart Studio config: `showLink`, `linkText`, `sendData`, `showSources`, `showEditInChartStudio` | Remove these keys. They warn and have no effect in v4. |
| Trace `stream`, all `*src` fields, `layout.hidesources` | Remove them. Generated constructors reject removed top-level fields. |
| `Choroplethmap.new(opacity: ...)` | Use `marker: %{opacity: ...}` (`marker.opacity`). |
| MathJax 2 | Use MathJax 3 or MathJax 4. |

Validation checks **top-level fields of generated structs** (`Plotly.Scatter.new/1`,
`Plotly.Layout.new/1`, etc.), not nested attributes or value types. These escape hatches
remain available, so passing a constructor is not full Plotly schema validation:

- Nested maps/keyword lists pass through, including unknown nested fields such as
  `marker: %{colorsrc: ...}`; Plotly.js ignores unsupported fields.
- Plain-map traces passed to `Figure.new(data: [...])` or `Figure.add_trace/2`
  bypass generated constructors and removed-trace stubs.
- A plain `layout` map in `Plotly.Figure` bypasses the layout constructor;
  `layout.mapbox` still gets a migration warning.
- `config` is a free-form map; only the six removed config keys above warn.

### Defaults and new capabilities

| Area | v4 behavior and options |
|---|---|
| Overlaying axes | Default `tickmode` is `"sync"`. Set it explicitly if the previous tick behavior matters. |
| Scatter matrices | `splom` axis `matches` defaults to `true`; set `false` for independent axes. |
| Geographic fitting | `geo.fitbounds` defaults to `"locations"`, fitting the initial view to data. Set `false` to opt out. `geo.minscale` / `geo.maxscale` bound zoom scale. |
| Country lookup | `country-iso-search` replaces the previous matcher. Review legacy country names; a few old entries are no longer recognized. |
| Shape legends | Dashed shapes now have dashed legend markers. |
| Sankey | `direction: "forward"` or `"reversed"` controls flow. `node.sort` and `link.sort` support `"auto"` or `"input"` ordering. |
| Map symbols | Colored icons, Maki 8.2 symbols and circle legend icons are supported. |
| Map rendering | MapLibre GL v6 requires WebGL2. Rotated or pitched scatter maps support lasso and box selection. |
| Downloads | The plot title supplies the default download filename. Add `"downloadJson"` to `modeBarButtonsToAdd` for JSON export. |
| Legend groups | `legend.groupdoubleclick` controls grouped legend double-click behavior. |
| Interaction timing | The default double-click delay is now 500 ms. |
| Responsive charts | `responsive: true` uses ResizeObserver in Plotly.js 4.1.2. The LiveView hook also observes its chart container. |

The color parser now uses **culori** and accepts modern CSS formats such as
`#3366CC80`, `rgb(255 0 0 / 0.5)`, `hsl(270 80% 50% / 0.6)` and `oklch(65% 0.2 145)`.
It rejects invalid CSS and `hsv()` strings. RGB decimal 0–1 channel values are
literal channel values, no longer fractions of 255; use 0–255 values or percentages.
An alpha argument in `rgb()` now takes effect. Automatic contrasting text/borders
use WCAG contrast ratios, which can change label colors.

Quiver is available through `Plotly.Quiver`, Express, and the smart cell:

```elixir
field = [%{"x" => 0, "y" => 0, "u" => 1, "v" => 2, "group" => "A"}]
Plotly.quiver(field, x: "x", y: "y", u: "u", v: "v", color: "group")
|> Plotly.show()
```

Kino widgets and the supplied LiveView hook load MathJax 4 on demand when figure
JSON contains `$`, awaiting startup before plotting. An existing MathJax 3/4
engine is reused. For Phoenix `static_plot/2`, load a compatible MathJax engine
yourself if the figure needs math rendering.

### Plotly Cloud is opt-in

`plotly_ex` disables the **Upload to Cloud** button on every render path, including
live updates. Enable it explicitly with `showSendToCloud: true`:

```elixir
Plotly.Figure.new(config: %{showSendToCloud: true})
|> Plotly.Figure.add_trace(Plotly.Scatter.new(x: [1, 2], y: [3, 5]))
|> Plotly.show()
```

`showSendToCloud` and `plotlyServerURL` remain supported; upstream's server is
`cloud.plotly.com`. This is distinct from the removed Chart Studio options.
The render default does not mutate the figure: `Figure.to_json/1` remains a faithful
serialization, while `Figure.to_render_json/1` applies the default when absent
and expands named templates.
For local JSON export instead, use `config: %{modeBarButtonsToAdd: ["downloadJson"]}`.

### Shared event payload contract

Kino subscriptions and the supplied LiveView hook forward the same JSON shape for
`plotly_click`, `plotly_hover`, `plotly_unhover`, and `plotly_selected`:

| Location | Fields |
|---|---|
| Event `data` | `points`, `xvals`, `yvals`, `xPixel`, `yPixel` |
| Each item in `data.points` | `x`, `y`, `z`, `curveNumber`, `pointNumber`, `pointIndex`, `text`, `customdata`, `name`, `bbox`, `xPixel`, `yPixel` |

Top-level `xPixel`/`yPixel` describe the **cursor** position relative to the graph
div. `points[i].xPixel`/`yPixel` describe the **point centre**, not the cursor.
All listed keys are present: missing values are JSON `null` (Elixir `nil`).
`points` is `[]` for events between points. `bbox` is also forwarded by both adapters.
Relayout retains its original event-specific JSON shape.

Enable `layout.hoveranywhere` / `layout.clickanywhere` to receive the same hover/click
events between points. `xvals`/`yvals` now contain axis data values: dates and
categories are strings; linear/log values retain their numeric form. With
`hoveranywhere`, leaving the plot emits `plotly_unhover`. Kino's filter is `:unhover`.
LiveView receives `handle_event("plotly_event", %{"type" => event_name, "data" => data}, socket)`.

---

## Development checks

From a source checkout with dependencies installed:

```bash
mix compile --warnings-as-errors
mix format --check-formatted
mix test
node --test test/js/*.test.mjs
cd phx_ex
mix test
```

Use Node.js 22 or later for the JavaScript tests. Run them directly for release
acceptance: the Elixir wrapper skips them when Node is unavailable.

## License

MIT License — see [LICENSE](LICENSE) for details.

```
MIT License

Copyright (c) 2026 plotly_ex contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

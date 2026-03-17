# plotly_ex

[![Hex.pm](https://img.shields.io/hexpm/v/plotly_ex.svg)](https://hex.pm/packages/plotly_ex)
[![HexDocs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/plotly_ex)
[![License](https://img.shields.io/hexpm/l/plotly_ex.svg)](https://github.com/pklonowski/plotly_ex/blob/main/LICENSE)

Interactive [Plotly.js](https://plotly.com/javascript/) charts for Elixir — works in
[Livebook](https://livebook.dev) via Kino and in Phoenix LiveView.

`plotly_ex` is an Elixir binding for [Plotly](https://plotly.com/) — a leading open-source
charting library with support for 50+ interactive chart types including statistical, financial,
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
- **50+ Plotly.js trace types** (scatter, bar, heatmap, 3D, maps, financial, …)
- **Live updates** via `PlotlyLive.push/2`
- **Browser event subscriptions** (click, hover, zoom)

---

## Installation

**In a Livebook notebook** (`Mix.install`):

```elixir
Mix.install([
  {:plotly_ex, "~> 0.1"},
  {:kino, "~> 0.14"},
  # optional — pass Explorer DataFrames to Express functions:
  {:explorer, "~> 0.11"}
])
```

**In a Mix project** (`mix.exs`):

```elixir
def deps do
  [
    {:plotly_ex, "~> 0.1"},
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

### Fluent Builder

For full control over trace properties:

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
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :relayout)
Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events, :selected)
```

---

## Phoenix

### Static Embed (no LiveView)

For controller-rendered (dead) views, use `static_plot/2` — no hook registration needed.

**1. Add Plotly.js to your layout** (`lib/your_app_web/components/layouts/app.html.heex`):

```html
<script src="https://cdn.plot.ly/plotly-2.35.2.min.js"></script>
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

**1. Add Plotly.js to your layout** (`lib/your_app_web/components/layouts/app.html.heex`):

```html
<script src="https://cdn.plot.ly/plotly-2.35.2.min.js"></script>
```

**2. Register the hook** (`assets/js/app.js`):

Import directly from the library (includes event forwarding, render-race protection, and `RawJS` support):

```js
import { PlotlyChart } from "../../deps/plotly_ex/priv/static/plotly_hook.js"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { PlotlyChart }
})
```

Or vendor a minimal hook by saving this to `assets/js/plotly_hook.js`:

```js
// assets/js/plotly_hook.js
export const PlotlyChart = {
  mounted() {
    const fig = JSON.parse(this.el.dataset.figure);
    Plotly.newPlot(this.el, fig.data || [], fig.layout || {}, fig.config || {});
    this._observer = new ResizeObserver(() => Plotly.Plots.resize(this.el));
    this._observer.observe(this.el);
  },
  updated() {
    const fig = JSON.parse(this.el.dataset.figure);
    Plotly.react(this.el, fig.data || [], fig.layout || {}, fig.config || {});
  },
  destroyed() {
    if (this._observer) this._observer.disconnect();
    Plotly.purge(this.el);
  }
};
```

Then import it in `app.js`:

```js
import { PlotlyChart } from "./plotly_hook.js"
```

> The full hook in `deps/plotly_ex/priv/static/plotly_hook.js` adds click/hover/zoom event forwarding to LiveView, render-race protection, and `RawJS` support — use it if you need those features.

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

def handle_event("plotly_click", %{"data" => %{"points" => points}}, socket) do
  IO.inspect(points, label: "clicked")
  {:noreply, socket}
end
```

The component calls `Plotly.react` on each assign update — only changed data is re-rendered.

---

## Notebooks

The `notebooks/` directory contains 16 runnable Livebook examples covering every chart type.

**How to open them:**
1. Start Livebook: `livebook server` (or open the Livebook desktop app)
2. Click **Open** → navigate to this repo's `notebooks/` folder
3. Open any `.livemd` file and run the cells

| Notebook | Coverage |
|---|---|
| `01_express.livemd` | Express API: all chart types in one call |
| `02_builder.livemd` | Fluent builder, trace options |
| `03a_fundamentals_config.livemd` | Configuration & display settings |
| `03b_fundamentals_styling.livemd` | Colors, axes, hover templates |
| `03c_fundamentals_shapes.livemd` | Shapes & annotations |
| `04_basic_charts.livemd` | Scatter, bar, pie, table, WebGL |
| `05_statistical.livemd` | Histogram, box, violin, heatmap |
| `06_scientific.livemd` | Contour, surface, 3D, polar |
| `07_financial.livemd` | Candlestick, OHLC, waterfall |
| `08_maps.livemd` | Choropleth, scatter geo, tile maps |
| `09_3d.livemd` | 3D scatter, surface, mesh |
| `10_subplots.livemd` | Grid layouts, shared axes |
| `11_custom_controls.livemd` | Buttons, sliders, dropdowns |
| `12_animations.livemd` | Frame-based animations |
| `13_chart_events.livemd` | Click, hover, zoom events |
| `14_kino_smart_cell.livemd` | SmartCell walkthrough |

---

## Example Phoenix Project (`phx_ex/`)

`phx_ex/` is a standalone Phoenix application demonstrating `plotly_ex` integration in a LiveView.

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

```elixir
# config/config.exs
config :plotly_ex, :plotly_js,
  version: "2.35.2",  # Plotly.js version loaded from CDN
  source: :cdn        # :cdn (default)
```

---

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

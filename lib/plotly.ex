defmodule Plotly do
  @moduledoc """
  Top-level convenience module for plotly_ex.

  ## Express API

  One-call chart building. Accepts lists of atom- or string-keyed maps or Explorer DataFrames.
  Returns a `Plotly.Figure` ready to pipe into `show/1`.

      iex> fig = Plotly.scatter([%{"x" => 1, "y" => 2}], x: "x", y: "y"); :ok
      :ok
      iex> is_struct(fig, Plotly.Figure)
      true

  | Function | Required opts | Notes |
  |----------|--------------|-------|
  | `scatter/2`, `bar/2`, `line/2` | `:x`, `:y` | |
  | `quiver/2` | `:x`, `:y`, `:u`, `:v` | optional `:color` |
  | `histogram/2` | `:x` | |
  | `box/2`, `violin/2`, `waterfall/2`, `funnel/2` | `:x`, `:y` | |
  | `pie/2` | `:values` | optional `:names` |
  | `scatter3d/2` | `:x`, `:y`, `:z` | |
  | `scattergeo/2`, `scattermap/2` | `:lat`, `:lon` | |
  | `choropleth/2` | `:locations`, `:z` | |
  | `scatterpolar/2`, `barpolar/2` | `:r`, `:theta` | |
  | `indicator/2` | `:value` | |
  | `histogram2d/2` | `:x`, `:y` | |
  | `sunburst/2`, `treemap/2` | `:labels`, `:parents` | |
  | `candlestick/2`, `ohlc/2` | `:x`, `:open`, `:high`, `:low`, `:close` | |

  ### Express-level options (apply to all functions)

  - `:title` — chart title
  - `:width`, `:height` — pixel dimensions
  - `:color` — group by a column (scatter, bar, line, and quiver; each group becomes a trace)
  - `:template` — bundled template name or inline template map (e.g. `"plotly_dark"`)

  ## Fluent Builder

      # Build a chart step-by-step
      iex> Plotly.figure().data
      []

  ## Quick start

      # Express API — accepts plain lists of maps or Explorer DataFrames
      Plotly.scatter(data, x: "date", y: "price") |> Plotly.show()

      # Fluent builder
      Plotly.figure()
      |> Plotly.Figure.add_trace(Plotly.Scatter.new(x: [1,2,3], y: [4,5,6]))
      |> Plotly.Figure.update_layout(title: "My Chart")
      |> Plotly.show()
  """

  @doc """
  Create a new empty `Plotly.Figure`. Accepts any `Plotly.Figure` field as opts.

  Use the fluent builder to add traces and layout options step-by-step.

  ## Examples

      # Empty figure — add traces via Plotly.Figure.add_trace/2
      Plotly.figure()
      |> Plotly.Figure.add_trace(Plotly.Scatter.new(x: [1, 2, 3], y: [4, 5, 6]))
      |> Plotly.Figure.update_layout(title: "My Chart")
      |> Plotly.show()

      # With initial layout
      Plotly.figure(layout: %{title: "Revenue", paper_bgcolor: "#fafafa"})

      iex> Plotly.figure().data
      []
  """
  def figure(opts \\ []), do: Plotly.Figure.new(opts)

  @doc """
  Render a figure in the current environment.

  - **Livebook**: returns a `Kino.JS.Live` widget that renders inline.
    Requires `{:kino, "~> 0.14"}` in deps.
  - **Phoenix LiveView**: use `Plotly.Phoenix.Component.plot/1` instead.
  - Raises with a helpful message if Kino is not installed.

  Accepts an optional keyword list as a second argument:
  - `:config` — a map merged into the figure's config (e.g. `%{locale: "fr"}`)

  **Plotly.js v4 removals:** config keys `showLink`, `linkText`, `sendData`,
  `showSources`, `showEditInChartStudio`, and `mapboxAccessToken` emit a migration
  warning. `plotlyServerURL` and `showSendToCloud` remain supported for Plotly
  Cloud; upload is disabled by default when rendering and can be opted into.

  ## Examples

      data = [
        %{"month" => "Jan", "sales" => 42},
        %{"month" => "Feb", "sales" => 55},
        %{"month" => "Mar", "sales" => 38}
      ]

      Plotly.bar(data, x: "month", y: "sales", title: "Monthly Sales")
      |> Plotly.show()

      # With locale config
      Plotly.scatter(data, x: "date", y: "value")
      |> Plotly.show(config: %{locale: "fr"})

      # Fluent builder
      Plotly.figure()
      |> Plotly.Figure.add_trace(Plotly.Scatter.new(x: [1, 2, 3], y: [4, 5, 6]))
      |> Plotly.show()
  """
  def show(%Plotly.Figure{} = fig, opts) when is_list(opts) do
    config = Keyword.get(opts, :config, %{})
    show(%{fig | config: Map.merge(fig.config, config)})
  end

  def show(%Plotly.Figure{} = fig) do
    Plotly.Deprecations.warn_removed_config(fig.config)

    if Code.ensure_loaded?(Plotly.Kino.PlotlyLive) do
      apply(Plotly.Kino.PlotlyLive, :new, [fig])
    else
      raise """
      Plotly.show/1 requires the :kino dependency.
      Add {:kino, "~> 0.14"} to your mix.exs deps and recompile,
      or use Plotly.Figure.to_json/1 to get the JSON string directly.
      For Phoenix LiveView, use Plotly.Phoenix.Component.plot/1.
      """
    end
  end

  # Express delegates — opts \\ [] so hover docs show correctly.

  @doc """
  Express scatter plot.

  Required: `:x`, `:y`. Optional: `:color`, `:title`, `:width`, `:height`, `:template`.

  ## Examples

      data = [
        %{"date" => "2024-01", "price" => 120.5},
        %{"date" => "2024-02", "price" => 132.0},
        %{"date" => "2024-03", "price" => 119.8}
      ]

      Plotly.scatter(data, x: "date", y: "price", title: "Price History")
      |> Plotly.show()

      # :color groups rows into separate traces — one per unique value
      Plotly.scatter(market_data, x: "date", y: "close", color: "ticker")
      |> Plotly.show()
  """
  def scatter(data, opts \\ []), do: Plotly.Express.scatter(data, opts)

  @doc """
  Express vector field plot.

  Required column selectors: `:x`, `:y`, `:u`, `:v`.
  Optional: `:color`, `:title`, `:width`, `:height`, `:template`.
  See `Plotly.Express.quiver/2` for examples and trace options.
  """
  def quiver(data, opts \\ []), do: Plotly.Express.quiver(data, opts)

  @doc """
  Express bar chart.

  Required: `:x`, `:y`. Optional: `:color` (grouped bars — one trace per group),
  `:title`, `:width`, `:height`, `:template`.

  ## Examples

      monthly = [
        %{"month" => "Jan", "sales" => 1200},
        %{"month" => "Feb", "sales" => 1450},
        %{"month" => "Mar", "sales" => 1100}
      ]

      Plotly.bar(monthly, x: "month", y: "sales", title: "Monthly Sales")
      |> Plotly.show()

      # Grouped bar chart — one bar series per region
      Plotly.bar(regional_data, x: "quarter", y: "revenue", color: "region")
      |> Plotly.show()
  """
  def bar(data, opts \\ []), do: Plotly.Express.bar(data, opts)

  @doc """
  Express line chart.

  Required: `:x`, `:y`. Optional: `:color`, `:title`, `:width`, `:height`, `:template`.

  ## Examples

      Plotly.line(time_series, x: "date", y: "value", title: "Trend")
      |> Plotly.show()

      # Multiple lines via color grouping
      Plotly.line(multi_series, x: "date", y: "value", color: "series")
      |> Plotly.show()
  """
  def line(data, opts \\ []), do: Plotly.Express.line(data, opts)

  @doc """
  Express histogram.

  Required: `:x`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      data = Enum.map(1..500, fn _ -> %{"score" => :rand.normal(70, 10)} end)

      Plotly.histogram(data, x: "score", title: "Score Distribution")
      |> Plotly.show()
  """
  def histogram(data, opts \\ []), do: Plotly.Express.histogram(data, opts)

  @doc """
  Express box plot.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      Plotly.box(results, x: "group", y: "value", title: "Distribution by Group")
      |> Plotly.show()
  """
  def box(data, opts \\ []), do: Plotly.Express.box(data, opts)

  @doc """
  Express pie chart.

  Required: `:values`. Optional: `:names`, `:title`, `:width`, `:height`.

  ## Examples

      browser_share = [
        %{"browser" => "Chrome", "pct" => 65},
        %{"browser" => "Firefox", "pct" => 18},
        %{"browser" => "Safari", "pct" => 12},
        %{"browser" => "Other", "pct" => 5}
      ]

      Plotly.pie(browser_share, values: "pct", names: "browser", title: "Browser Share")
      |> Plotly.show()
  """
  def pie(data, opts \\ []), do: Plotly.Express.pie(data, opts)

  @doc """
  Express violin plot.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      Plotly.violin(measurements, x: "category", y: "value", title: "Distribution")
      |> Plotly.show()
  """
  def violin(data, opts \\ []), do: Plotly.Express.violin(data, opts)

  @doc """
  Express candlestick chart.

  Required: `:x`, `:open`, `:high`, `:low`, `:close`.
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      prices = [
        %{"date" => "2024-01-01", "o" => 150, "h" => 158, "l" => 148, "c" => 155},
        %{"date" => "2024-01-02", "o" => 155, "h" => 162, "l" => 153, "c" => 160}
      ]

      Plotly.candlestick(prices,
        x: "date", open: "o", high: "h", low: "l", close: "c",
        title: "AAPL Jan 2024"
      )
      |> Plotly.show()
  """
  def candlestick(data, opts \\ []), do: Plotly.Express.candlestick(data, opts)

  @doc """
  Express OHLC chart.

  Required: `:x`, `:open`, `:high`, `:low`, `:close`.
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.ohlc(prices, x: "date", open: "o", high: "h", low: "l", close: "c")
      |> Plotly.show()
  """
  def ohlc(data, opts \\ []), do: Plotly.Express.ohlc(data, opts)

  @doc """
  Express waterfall chart.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      cashflow = [
        %{"item" => "Revenue", "amount" => 500},
        %{"item" => "COGS", "amount" => -200},
        %{"item" => "Gross Profit", "amount" => 300}
      ]

      Plotly.waterfall(cashflow, x: "item", y: "amount", title: "P&L Waterfall")
      |> Plotly.show()
  """
  def waterfall(data, opts \\ []), do: Plotly.Express.waterfall(data, opts)

  @doc """
  Express sunburst chart.

  Required: `:labels`, `:parents`. Optional: `:values`, `:title`, `:width`, `:height`.

  ## Examples

      hierarchy = [
        %{"id" => "World", "parent" => "", "pop" => 8000},
        %{"id" => "Asia", "parent" => "World", "pop" => 4600},
        %{"id" => "Europe", "parent" => "World", "pop" => 750}
      ]

      Plotly.sunburst(hierarchy, labels: "id", parents: "parent", values: "pop")
      |> Plotly.show()
  """
  def sunburst(data, opts \\ []), do: Plotly.Express.sunburst(data, opts)

  @doc """
  Express treemap chart.

  Required: `:labels`, `:parents`. Optional: `:values`, `:title`, `:width`, `:height`.

  ## Examples

      Plotly.treemap(hierarchy, labels: "id", parents: "parent", values: "size")
      |> Plotly.show()
  """
  def treemap(data, opts \\ []), do: Plotly.Express.treemap(data, opts)

  @doc """
  Express 3D scatter chart.

  Required: `:x`, `:y`, `:z`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      points = [
        %{"x" => 1, "y" => 2, "z" => 3},
        %{"x" => 4, "y" => 5, "z" => 6},
        %{"x" => 7, "y" => 8, "z" => 9}
      ]

      Plotly.scatter3d(points, x: "x", y: "y", z: "z", title: "3D Scatter")
      |> Plotly.show()
  """
  def scatter3d(data, opts \\ []), do: Plotly.Express.scatter3d(data, opts)

  @doc """
  Express geographic scatter chart (geo projection).

  Required: `:lat`, `:lon`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      cities = [
        %{"city" => "London", "lat" => 51.5, "lon" => -0.1, "pop" => 9_000_000},
        %{"city" => "Tokyo", "lat" => 35.7, "lon" => 139.7, "pop" => 14_000_000}
      ]

      Plotly.scattergeo(cities, lat: "lat", lon: "lon", title: "World Cities")
      |> Plotly.show()
  """
  def scattergeo(data, opts \\ []), do: Plotly.Express.scattergeo(data, opts)

  @doc """
  Express choropleth map.

  Required: `:locations`, `:z`. Defaults `locationmode` to `"ISO-3"`.
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      gdp = [
        %{"iso" => "USA", "gdp" => 23_000},
        %{"iso" => "DEU", "gdp" => 4_200},
        %{"iso" => "CHN", "gdp" => 18_000}
      ]

      Plotly.choropleth(gdp, locations: "iso", z: "gdp", title: "GDP by Country")
      |> Plotly.show()
  """
  def choropleth(data, opts \\ []), do: Plotly.Express.choropleth(data, opts)

  @doc """
  Express tile map scatter (uses `open-street-map` by default, no API key needed).

  Required: `:lat`, `:lon`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      stations = [
        %{"name" => "London", "lat" => 51.5074, "lon" => -0.1278},
        %{"name" => "Paris", "lat" => 48.8566, "lon" => 2.3522},
        %{"name" => "Berlin", "lat" => 52.5200, "lon" => 13.4050}
      ]

      Plotly.scattermap(stations, lat: "lat", lon: "lon", title: "European Capitals")
      |> Plotly.show()
  """
  def scattermap(data, opts \\ []), do: Plotly.Express.scattermap(data, opts)

  @doc """
  Express funnel chart.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      funnel_data = [
        %{"stage" => "Leads", "count" => 1000},
        %{"stage" => "Qualified", "count" => 400},
        %{"stage" => "Proposals", "count" => 150},
        %{"stage" => "Closed", "count" => 60}
      ]

      Plotly.funnel(funnel_data, x: "count", y: "stage", title: "Sales Funnel")
      |> Plotly.show()
  """
  def funnel(data, opts \\ []), do: Plotly.Express.funnel(data, opts)

  @doc """
  Express polar scatter chart.

  Required: `:r`, `:theta`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      wind = Enum.map(0..11, fn i ->
        %{"deg" => i * 30, "speed" => :rand.uniform(20)}
      end)

      Plotly.scatterpolar(wind, r: "speed", theta: "deg", title: "Wind Rose")
      |> Plotly.show()
  """
  def scatterpolar(data, opts \\ []), do: Plotly.Express.scatterpolar(data, opts)

  @doc """
  Express polar bar chart.

  Required: `:r`, `:theta`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.barpolar(wind_data, r: "frequency", theta: "direction")
      |> Plotly.show()
  """
  def barpolar(data, opts \\ []), do: Plotly.Express.barpolar(data, opts)

  @doc """
  Express 2D histogram (density heatmap).

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.histogram2d(scatter_data, x: "height", y: "weight", title: "Height vs Weight Density")
      |> Plotly.show()
  """
  def histogram2d(data, opts \\ []), do: Plotly.Express.histogram2d(data, opts)

  @doc """
  Express indicator / gauge chart.

  Required: `:value` (first row's value is used).
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.indicator([%{"kpi" => 92.5}], value: "kpi", title: "Satisfaction Score")
      |> Plotly.show()
  """
  def indicator(data, opts \\ []), do: Plotly.Express.indicator(data, opts)
end

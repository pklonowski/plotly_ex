defmodule Plotly.Express do
  @moduledoc """
  High-level Express-style API. Accepts Explorer DataFrames or plain lists of
  **string-keyed** maps (e.g. `[%{"col" => value}]`).

  Returns a `Plotly.Figure` ready to pipe into `Plotly.show/1`.

  ## Express-level options

  These options are consumed by `Plotly.Express` before the trace is built.
  Everything else is forwarded to the underlying trace struct as-is.

  - `:color` — group rows by a column value; each unique value becomes a separate trace.
    Supported by `scatter/2`, `bar/2`, and `line/2`.
  - `:title` — sets `layout.title`
  - `:width`, `:height` — set `layout.width` / `layout.height` (pixels)
  - `:template` — sets `layout.template` (Plotly.js built-in template name,
    e.g. `"plotly_dark"`, `"plotly_white"`, `"ggplot2"`)

  ## Data shapes accepted

  **List of string-keyed maps** — most common:

      data = [
        %{"month" => "Jan", "sales" => 42},
        %{"month" => "Feb", "sales" => 55}
      ]

      Plotly.Express.bar(data, x: "month", y: "sales", title: "Revenue")
      |> Plotly.show()

  **Explorer DataFrame** — requires `{:explorer, "~> 0.11"}` in deps:

      df = Explorer.DataFrame.from_csv!("data.csv")
      Plotly.Express.scatter(df, x: "date", y: "price")
      |> Plotly.show()
  """

  # Options consumed at the Express layer. Everything else is forwarded to the trace struct.
  @express_opts [
    :color,
    :title,
    :template,
    :labels,
    :width,
    :height
  ]

  # :labels is a column selector for sunburst/treemap — must not be stripped at Express layer.
  @hierarchy_express_opts @express_opts -- [:labels]

  @doc """
  Scatter chart.

  Required: `:x`, `:y`. Optional: `:color`, `:title`, `:width`, `:height`, `:template`.

  ## Examples

      data = [
        %{"year" => 2020, "sales" => 120},
        %{"year" => 2021, "sales" => 145},
        %{"year" => 2022, "sales" => 180}
      ]

      Plotly.Express.scatter(data, x: "year", y: "sales", title: "Annual Sales")
      |> Plotly.show()

      # :color groups rows into separate traces — one per unique value
      Plotly.Express.scatter(market_data, x: "date", y: "close", color: "ticker")
      |> Plotly.show()

      iex> data = [%{"a" => 1, "b" => 2}, %{"a" => 3, "b" => 4}]; :ok
      :ok
      iex> fig = Plotly.Express.scatter(data, x: "a", y: "b"); :ok
      :ok
      iex> hd(fig.data).x
      [1, 3]
  """
  def scatter(data, opts \\ []) do
    opts = Keyword.put_new(opts, :mode, "markers")
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)

    traces =
      case Keyword.get(express_opts, :color) do
        nil ->
          clean = Keyword.drop(trace_opts, [:x, :y])
          [Plotly.Scatter.new([x: x, y: y] ++ clean)]

        color_key ->
          build_color_traces(data, color_key, trace_opts, &Plotly.Scatter.new/1)
      end

    layout = build_layout(express_opts)
    Plotly.Figure.new(data: traces, layout: layout)
  end

  @doc """
  Bar chart.

  Required: `:x`, `:y`. Optional: `:color` (grouped bars — one trace per group),
  `:title`, `:width`, `:height`, `:template`.

  ## Examples

      monthly = [
        %{"month" => "Jan", "sales" => 1200},
        %{"month" => "Feb", "sales" => 1450},
        %{"month" => "Mar", "sales" => 1100}
      ]

      Plotly.Express.bar(monthly, x: "month", y: "sales", title: "Monthly Sales")
      |> Plotly.show()

      # Grouped bar chart — one bar series per region
      Plotly.Express.bar(regional_data, x: "quarter", y: "revenue", color: "region")
      |> Plotly.show()

      iex> data = [%{"x" => "A", "y" => 1, "g" => "r"}, %{"x" => "B", "y" => 2, "g" => "b"}]; :ok
      :ok
      iex> fig = Plotly.Express.bar(data, x: "x", y: "y", color: "g"); :ok
      :ok
      iex> length(fig.data)
      2
  """
  def bar(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)

    traces =
      case Keyword.get(express_opts, :color) do
        nil ->
          clean = Keyword.drop(trace_opts, [:x, :y])
          [Plotly.Bar.new([x: x, y: y] ++ clean)]

        color_key ->
          build_color_traces(data, color_key, trace_opts, &Plotly.Bar.new/1)
      end

    Plotly.Figure.new(data: traces, layout: build_layout(express_opts))
  end

  @doc """
  Line chart.

  Required: `:x`, `:y`. Optional: `:color`, `:title`, `:width`, `:height`, `:template`.

  ## Examples

      Plotly.Express.line(time_series, x: "date", y: "value", title: "Trend")
      |> Plotly.show()

      # Multiple lines via color grouping
      Plotly.Express.line(multi_series, x: "date", y: "value", color: "series")
      |> Plotly.show()
  """
  def line(data, opts \\ []) do
    # line is a scatter with mode forced to "lines"
    opts = Keyword.put(opts, :mode, "lines")
    scatter(data, opts)
  end

  @doc """
  Histogram.

  Required: `:x`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      data = Enum.map(1..500, fn _ -> %{"score" => :rand.normal(70.0, 10.0)} end)

      Plotly.Express.histogram(data, x: "score", title: "Score Distribution")
      |> Plotly.show()
  """
  def histogram(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    x_col = Keyword.fetch!(trace_opts, :x)
    xs = extract_column(data, x_col)
    clean = Keyword.drop(trace_opts, [:x, :y])
    trace = Plotly.Histogram.new([x: xs] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Box plot.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      Plotly.Express.box(results, x: "group", y: "value", title: "Distribution by Group")
      |> Plotly.show()
  """
  def box(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :y])
    trace = Plotly.Box.new([x: x, y: y] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Pie chart.

  Required: `:values`. Optional: `:names`, `:title`, `:width`, `:height`.

  ## Examples

      browser_share = [
        %{"browser" => "Chrome", "pct" => 65},
        %{"browser" => "Firefox", "pct" => 18},
        %{"browser" => "Safari", "pct" => 12},
        %{"browser" => "Other", "pct" => 5}
      ]

      Plotly.Express.pie(browser_share,
        values: "pct", names: "browser", title: "Browser Market Share"
      )
      |> Plotly.show()

      iex> data = [%{"v" => 10}, %{"v" => 20}]; :ok
      :ok
      iex> fig = Plotly.Express.pie(data, values: "v"); :ok
      :ok
      iex> hd(fig.data).values
      [10, 20]
  """
  def pie(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    values_col = Keyword.fetch!(trace_opts, :values)
    names_col = Keyword.get(trace_opts, :names)
    values = extract_column(data, values_col)
    names = if names_col, do: extract_column(data, names_col), else: nil
    clean = Keyword.drop(trace_opts, [:values, :names])
    attrs = [values: values] ++ if(names, do: [labels: names], else: []) ++ clean
    trace = Plotly.Pie.new(attrs)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Violin plot.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      Plotly.Express.violin(measurements, x: "category", y: "value", title: "Distribution")
      |> Plotly.show()
  """
  def violin(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :y])
    trace = Plotly.Violin.new([x: x, y: y] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Candlestick chart.

  Required: `:x`, `:open`, `:high`, `:low`, `:close`.
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      prices = [
        %{"date" => "2024-01-01", "o" => 150, "h" => 158, "l" => 148, "c" => 155},
        %{"date" => "2024-01-02", "o" => 155, "h" => 162, "l" => 153, "c" => 160}
      ]

      Plotly.Express.candlestick(prices,
        x: "date", open: "o", high: "h", low: "l", close: "c",
        title: "AAPL Jan 2024"
      )
      |> Plotly.show()
  """
  def candlestick(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    cols = extract_ohlc(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :open, :high, :low, :close])

    trace =
      Plotly.Candlestick.new(
        [x: cols.x, open: cols.open, high: cols.high, low: cols.low, close: cols.close] ++ clean
      )

    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  OHLC chart.

  Required: `:x`, `:open`, `:high`, `:low`, `:close`.
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.Express.ohlc(prices,
        x: "date", open: "open", high: "high", low: "low", close: "close"
      )
      |> Plotly.show()
  """
  def ohlc(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    cols = extract_ohlc(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :open, :high, :low, :close])

    trace =
      Plotly.Ohlc.new(
        [x: cols.x, open: cols.open, high: cols.high, low: cols.low, close: cols.close] ++ clean
      )

    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Waterfall chart.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      cashflow = [
        %{"item" => "Revenue", "amount" => 500},
        %{"item" => "COGS", "amount" => -200},
        %{"item" => "Gross Profit", "amount" => 300}
      ]

      Plotly.Express.waterfall(cashflow, x: "item", y: "amount", title: "P&L Waterfall")
      |> Plotly.show()
  """
  def waterfall(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :y])
    trace = Plotly.Waterfall.new([x: x, y: y] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Sunburst chart.

  Required: `:labels`, `:parents`. Optional: `:values`, `:title`, `:width`, `:height`.

  ## Examples

      hierarchy = [
        %{"id" => "World", "parent" => "", "pop" => 8_000},
        %{"id" => "Asia", "parent" => "World", "pop" => 4_600},
        %{"id" => "Europe", "parent" => "World", "pop" => 750}
      ]

      Plotly.Express.sunburst(hierarchy,
        labels: "id", parents: "parent", values: "pop", title: "Population by Region"
      )
      |> Plotly.show()
  """
  def sunburst(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @hierarchy_express_opts)
    labels_col = Keyword.fetch!(trace_opts, :labels)
    parents_col = Keyword.fetch!(trace_opts, :parents)
    values_col = Keyword.get(trace_opts, :values)
    labels = extract_column(data, labels_col)
    parents = extract_column(data, parents_col)
    values = if values_col, do: extract_column(data, values_col), else: nil
    clean = Keyword.drop(trace_opts, [:labels, :parents, :values])

    attrs =
      [labels: labels, parents: parents] ++ if(values, do: [values: values], else: []) ++ clean

    trace = Plotly.Sunburst.new(attrs)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Treemap chart.

  Required: `:labels`, `:parents`. Optional: `:values`, `:title`, `:width`, `:height`.

  ## Examples

      Plotly.Express.treemap(hierarchy, labels: "id", parents: "parent", values: "size")
      |> Plotly.show()
  """
  def treemap(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @hierarchy_express_opts)
    labels_col = Keyword.fetch!(trace_opts, :labels)
    parents_col = Keyword.fetch!(trace_opts, :parents)
    values_col = Keyword.get(trace_opts, :values)
    labels = extract_column(data, labels_col)
    parents = extract_column(data, parents_col)
    values = if values_col, do: extract_column(data, values_col), else: nil
    clean = Keyword.drop(trace_opts, [:labels, :parents, :values])

    attrs =
      [labels: labels, parents: parents] ++ if(values, do: [values: values], else: []) ++ clean

    trace = Plotly.Treemap.new(attrs)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  3D scatter chart.

  Required: `:x`, `:y`, `:z`. Optional: `:title`, `:width`, `:height`, `:template`.

  ## Examples

      points = [
        %{"x" => 1, "y" => 2, "z" => 3},
        %{"x" => 4, "y" => 5, "z" => 6},
        %{"x" => 7, "y" => 8, "z" => 9}
      ]

      Plotly.Express.scatter3d(points, x: "x", y: "y", z: "z", title: "3D Scatter")
      |> Plotly.show()
  """
  def scatter3d(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    x_col = Keyword.fetch!(trace_opts, :x)
    y_col = Keyword.fetch!(trace_opts, :y)
    z_col = Keyword.fetch!(trace_opts, :z)
    x = extract_column(data, x_col)
    y = extract_column(data, y_col)
    z = extract_column(data, z_col)
    clean = Keyword.drop(trace_opts, [:x, :y, :z])
    trace = Plotly.Scatter3d.new([x: x, y: y, z: z] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Geographic scatter chart (geo projection).

  Required: `:lat`, `:lon`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      cities = [
        %{"city" => "London", "lat" => 51.5, "lon" => -0.1, "pop" => 9_000_000},
        %{"city" => "Tokyo", "lat" => 35.7, "lon" => 139.7, "pop" => 14_000_000}
      ]

      Plotly.Express.scattergeo(cities, lat: "lat", lon: "lon", title: "World Cities")
      |> Plotly.show()
  """
  def scattergeo(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    lat_col = Keyword.fetch!(trace_opts, :lat)
    lon_col = Keyword.fetch!(trace_opts, :lon)
    lats = extract_column(data, lat_col)
    lons = extract_column(data, lon_col)
    clean = Keyword.drop(trace_opts, [:lat, :lon])
    trace = Plotly.Scattergeo.new([lat: lats, lon: lons] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Choropleth map.

  Required: `:locations`, `:z`. Defaults `locationmode` to `"ISO-3"`.
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      gdp = [
        %{"iso" => "USA", "gdp" => 23_000},
        %{"iso" => "DEU", "gdp" => 4_200},
        %{"iso" => "CHN", "gdp" => 18_000}
      ]

      Plotly.Express.choropleth(gdp, locations: "iso", z: "gdp", title: "GDP by Country")
      |> Plotly.show()
  """
  def choropleth(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    locations_col = Keyword.fetch!(trace_opts, :locations)
    z_col = Keyword.fetch!(trace_opts, :z)
    locations = extract_column(data, locations_col)
    z = extract_column(data, z_col)

    clean =
      trace_opts
      |> Keyword.drop([:locations, :z])
      |> Keyword.put_new(:locationmode, "ISO-3")

    trace = Plotly.Choropleth.new([locations: locations, z: z] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Tile map scatter (uses `open-street-map` by default, no API key needed).

  Required: `:lat`, `:lon`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      stations = [
        %{"name" => "London", "lat" => 51.5074, "lon" => -0.1278},
        %{"name" => "Paris", "lat" => 48.8566, "lon" => 2.3522},
        %{"name" => "Berlin", "lat" => 52.5200, "lon" => 13.4050}
      ]

      Plotly.Express.scattermap(stations, lat: "lat", lon: "lon", title: "European Capitals")
      |> Plotly.show()
  """
  def scattermap(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    lat_col = Keyword.fetch!(trace_opts, :lat)
    lon_col = Keyword.fetch!(trace_opts, :lon)
    lats = extract_column(data, lat_col)
    lons = extract_column(data, lon_col)
    clean = Keyword.drop(trace_opts, [:lat, :lon])
    trace = Plotly.Scattermap.new([lat: lats, lon: lons] ++ clean)
    layout = build_layout(express_opts) |> Map.put_new(:map, %{style: "open-street-map"})
    Plotly.Figure.new(data: [trace], layout: layout)
  end

  @doc """
  Polar scatter chart.

  Required: `:r`, `:theta`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      wind = Enum.map(0..11, fn i -> %{"deg" => i * 30, "speed" => :rand.uniform(20)} end)

      Plotly.Express.scatterpolar(wind, r: "speed", theta: "deg", title: "Wind Rose")
      |> Plotly.show()
  """
  def scatterpolar(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    r_col = Keyword.fetch!(trace_opts, :r)
    theta_col = Keyword.fetch!(trace_opts, :theta)
    r = extract_column(data, r_col)
    theta = extract_column(data, theta_col)
    clean = Keyword.drop(trace_opts, [:r, :theta])
    trace = Plotly.Scatterpolar.new([r: r, theta: theta] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Indicator / gauge chart.

  Required: `:value` (first row's value is used).
  Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.Express.indicator([%{"kpi" => 92.5}], value: "kpi", title: "Satisfaction Score")
      |> Plotly.show()
  """
  def indicator(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    value_col = Keyword.fetch!(trace_opts, :value)
    value = data |> extract_column(value_col) |> List.first()
    clean = Keyword.drop(trace_opts, [:value])
    trace = Plotly.Indicator.new([value: value] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  2D histogram (density heatmap).

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.Express.histogram2d(measurements, x: "height", y: "weight",
        title: "Height vs Weight Density"
      )
      |> Plotly.show()
  """
  def histogram2d(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :y])
    trace = Plotly.Histogram2d.new([x: x, y: y] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Polar bar chart.

  Required: `:r`, `:theta`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      Plotly.Express.barpolar(wind_data, r: "frequency", theta: "direction")
      |> Plotly.show()
  """
  def barpolar(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    r_col = Keyword.fetch!(trace_opts, :r)
    theta_col = Keyword.fetch!(trace_opts, :theta)
    r = extract_column(data, r_col)
    theta = extract_column(data, theta_col)
    clean = Keyword.drop(trace_opts, [:r, :theta])
    trace = Plotly.Barpolar.new([r: r, theta: theta] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  @doc """
  Funnel chart.

  Required: `:x`, `:y`. Optional: `:title`, `:width`, `:height`.

  ## Examples

      funnel_data = [
        %{"stage" => "Leads", "count" => 1000},
        %{"stage" => "Qualified", "count" => 400},
        %{"stage" => "Proposals", "count" => 150},
        %{"stage" => "Closed", "count" => 60}
      ]

      Plotly.Express.funnel(funnel_data, x: "count", y: "stage", title: "Sales Funnel")
      |> Plotly.show()
  """
  def funnel(data, opts \\ []) do
    {express_opts, trace_opts} = Keyword.split(opts, @express_opts)
    {x, y} = extract_xy(data, trace_opts)
    clean = Keyword.drop(trace_opts, [:x, :y])
    trace = Plotly.Funnel.new([x: x, y: y] ++ clean)
    Plotly.Figure.new(data: [trace], layout: build_layout(express_opts))
  end

  # --- Private helpers ---

  # Normalises the column key to match the row's key type.
  # Keyword list rows use atom keys; map rows use string keys.
  # Accepts either atom or string as col name regardless of row type.
  defp get_col(row, col) when is_list(row) do
    atom = if is_atom(col), do: col, else: String.to_existing_atom(col)
    row[atom]
  end

  defp get_col(row, col) when is_map(row) do
    str = if is_binary(col), do: col, else: Atom.to_string(col)
    row[str]
  end

  # Dispatch: Explorer.DataFrame struct vs plain list of maps
  defp extract_xy(%_{} = df, opts) do
    unless Code.ensure_loaded?(Explorer.DataFrame) do
      raise "Explorer is not loaded. Add {:explorer, \"~> 0.11\"} to your mix.exs deps."
    end

    x_col = Keyword.fetch!(opts, :x)
    y_col = Keyword.fetch!(opts, :y)
    {apply(Explorer.Series, :to_list, [df[x_col]]), apply(Explorer.Series, :to_list, [df[y_col]])}
  end

  defp extract_xy(data, opts) when is_list(data) do
    x_col = Keyword.fetch!(opts, :x)
    y_col = Keyword.fetch!(opts, :y)
    {Enum.map(data, &get_col(&1, x_col)), Enum.map(data, &get_col(&1, y_col))}
  end

  defp extract_column(%_{} = df, col) do
    apply(Explorer.Series, :to_list, [df[col]])
  end

  defp extract_column(data, col) when is_list(data) do
    Enum.map(data, &get_col(&1, col))
  end

  defp extract_ohlc(data, opts) when is_list(data) do
    x_col = Keyword.fetch!(opts, :x)
    open_col = Keyword.fetch!(opts, :open)
    high_col = Keyword.fetch!(opts, :high)
    low_col = Keyword.fetch!(opts, :low)
    close_col = Keyword.fetch!(opts, :close)

    %{
      x: Enum.map(data, &get_col(&1, x_col)),
      open: Enum.map(data, &get_col(&1, open_col)),
      high: Enum.map(data, &get_col(&1, high_col)),
      low: Enum.map(data, &get_col(&1, low_col)),
      close: Enum.map(data, &get_col(&1, close_col))
    }
  end

  defp extract_ohlc(%_{} = df, opts) do
    unless Code.ensure_loaded?(Explorer.DataFrame) do
      raise "Explorer is not loaded. Add {:explorer, \"~> 0.11\"} to your mix.exs deps."
    end

    x_col = Keyword.fetch!(opts, :x)
    open_col = Keyword.fetch!(opts, :open)
    high_col = Keyword.fetch!(opts, :high)
    low_col = Keyword.fetch!(opts, :low)
    close_col = Keyword.fetch!(opts, :close)

    %{
      x: apply(Explorer.Series, :to_list, [df[x_col]]),
      open: apply(Explorer.Series, :to_list, [df[open_col]]),
      high: apply(Explorer.Series, :to_list, [df[high_col]]),
      low: apply(Explorer.Series, :to_list, [df[low_col]]),
      close: apply(Explorer.Series, :to_list, [df[close_col]])
    }
  end

  # Build one trace per unique color-column value. Re-extracts x/y per group
  # so each trace holds only its own rows.
  defp build_color_traces(data, color_key, trace_opts, constructor) do
    x_col = Keyword.fetch!(trace_opts, :x)
    y_col = Keyword.fetch!(trace_opts, :y)
    clean = Keyword.drop(trace_opts, [:x, :y])
    groups = group_by_color(data, color_key)

    Enum.map(groups, fn {group_name, rows} ->
      xs = Enum.map(rows, &get_col(&1, x_col))
      ys = Enum.map(rows, &get_col(&1, y_col))
      constructor.([x: xs, y: ys, name: to_string(group_name)] ++ clean)
    end)
  end

  # Explorer.DataFrame: materialise to rows then group (simple, sufficient for v1)
  defp group_by_color(%_{} = df, color_key) do
    apply(Explorer.DataFrame, :to_rows, [df])
    |> Enum.group_by(& &1[color_key])
  end

  defp group_by_color(data, color_key) when is_list(data) do
    Enum.group_by(data, &get_col(&1, color_key))
  end

  defp build_layout(express_opts) do
    express_opts
    |> Keyword.take([:title, :width, :height, :template])
    |> Map.new()
  end
end

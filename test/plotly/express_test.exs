defmodule Plotly.ExpressTest do
  use ExUnit.Case, async: true
  doctest Plotly.Express

  alias Plotly.{
    Express,
    Figure,
    Scatter,
    Bar,
    Histogram,
    Histogram2d,
    Box,
    Pie,
    Violin,
    Candlestick,
    Ohlc,
    Waterfall,
    Funnel,
    Scatterpolar,
    Barpolar,
    Indicator,
    Sunburst,
    Treemap,
    Scatter3d,
    Scattergeo,
    Choropleth,
    Scattermap
  }

  @data [
    %{"x" => 1, "y" => 4, "cat" => "a"},
    %{"x" => 2, "y" => 5, "cat" => "b"},
    %{"x" => 3, "y" => 6, "cat" => "a"}
  ]

  @polar_data [
    %{"r" => 1.5, "theta" => 45},
    %{"r" => 2.0, "theta" => 90},
    %{"r" => 0.5, "theta" => 135}
  ]

  @kpi_data [%{"value" => 347}]

  @kw_data [
    [x: 1, y: 4, cat: "a"],
    [x: 2, y: 5, cat: "b"],
    [x: 3, y: 6, cat: "a"]
  ]

  @kw_hist_data [
    [height: 163],
    [height: 170],
    [height: 175]
  ]

  @kw_box_data [
    [group: "A", score: 72],
    [group: "A", score: 85],
    [group: "B", score: 55]
  ]

  describe "scatter/2 — no color" do
    test "returns a Figure" do
      fig = Express.scatter(@data, x: "x", y: "y")
      assert %Figure{} = fig
    end

    test "produces exactly one trace when no color given" do
      fig = Express.scatter(@data, x: "x", y: "y")
      assert length(fig.data) == 1
    end

    test "trace has correct x and y data" do
      fig = Express.scatter(@data, x: "x", y: "y")
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, 5, 6]
    end

    test "trace is a Scatter struct" do
      fig = Express.scatter(@data, x: "x", y: "y")
      [trace] = fig.data
      assert %Scatter{} = trace
    end

    test "raises KeyError when :x is missing" do
      assert_raise KeyError, fn ->
        Express.scatter(@data, y: "y")
      end
    end

    test "raises KeyError when :y is missing" do
      assert_raise KeyError, fn ->
        Express.scatter(@data, x: "x")
      end
    end

    test "extra trace opts (e.g. mode) pass through to the Scatter struct" do
      fig = Express.scatter(@data, x: "x", y: "y", mode: "markers")
      [trace] = fig.data
      assert trace.mode == "markers"
    end

    test "express opts (title, width, height) do NOT appear as trace fields" do
      fig = Express.scatter(@data, x: "x", y: "y", title: "My Chart", width: 800)
      [trace] = fig.data
      # struct! would have raised if these were passed as trace fields
      refute Map.has_key?(Map.from_struct(trace), :title)
      refute Map.has_key?(Map.from_struct(trace), :width)
    end

    test "title appears in layout" do
      fig = Express.scatter(@data, x: "x", y: "y", title: "My Chart")
      assert fig.layout.title == "My Chart"
    end

    test "width and height appear in layout" do
      fig = Express.scatter(@data, x: "x", y: "y", width: 800, height: 600)
      assert fig.layout.width == 800
      assert fig.layout.height == 600
    end

    test "template appears in layout when provided" do
      fig = Express.scatter(@data, x: "x", y: "y", template: "plotly_dark")
      assert fig.layout.template == "plotly_dark"
    end

    test "template does not appear as a trace field" do
      fig = Express.scatter(@data, x: "x", y: "y", template: "plotly_dark")
      [trace] = fig.data
      refute Map.has_key?(Map.from_struct(trace), :template)
    end
  end

  describe "scatter/2 — color grouping" do
    test "produces one trace per unique color value" do
      fig = Express.scatter(@data, x: "x", y: "y", color: "cat")
      # "a" and "b" are the two unique values
      assert length(fig.data) == 2
    end

    test "each trace name matches its group value" do
      fig = Express.scatter(@data, x: "x", y: "y", color: "cat")
      names = fig.data |> Enum.map(& &1.name) |> Enum.sort()
      assert names == ["a", "b"]
    end

    test "each trace contains only its group's rows" do
      fig = Express.scatter(@data, x: "x", y: "y", color: "cat")
      trace_a = Enum.find(fig.data, &(&1.name == "a"))
      # rows with cat="a" are x=1 (y=4) and x=3 (y=6)
      assert Enum.sort(trace_a.x) == [1, 3]
    end

    test "color key itself does NOT appear as a trace field" do
      fig = Express.scatter(@data, x: "x", y: "y", color: "cat")
      [trace | _] = fig.data
      refute Map.has_key?(Map.from_struct(trace), :color)
    end
  end

  describe "bar/2" do
    test "returns a Figure" do
      fig = Express.bar(@data, x: "x", y: "y")
      assert %Figure{} = fig
    end

    test "produces one Bar trace when no color given" do
      fig = Express.bar(@data, x: "x", y: "y")
      assert [%Bar{}] = fig.data
    end

    test "bar trace has correct x and y" do
      fig = Express.bar(@data, x: "x", y: "y")
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, 5, 6]
    end

    test "color: produces one Bar trace per unique value" do
      fig = Express.bar(@data, x: "x", y: "y", color: "cat")
      assert length(fig.data) == 2
      assert Enum.all?(fig.data, &match?(%Bar{}, &1))
    end

    test "raises KeyError when :x is missing" do
      assert_raise KeyError, fn -> Express.bar(@data, y: "y") end
    end

    test "raises KeyError when :y is missing" do
      assert_raise KeyError, fn -> Express.bar(@data, x: "x") end
    end
  end

  describe "line/2" do
    test "returns a Figure" do
      fig = Express.line(@data, x: "x", y: "y")
      assert %Figure{} = fig
    end

    test "produces a Scatter trace (line is scatter with mode forced)" do
      fig = Express.line(@data, x: "x", y: "y")
      assert [%Scatter{}] = fig.data
    end

    test "trace mode is \"lines\"" do
      fig = Express.line(@data, x: "x", y: "y")
      [trace] = fig.data
      assert trace.mode == "lines"
    end

    test "caller-supplied mode is ignored in favour of \"lines\"" do
      # put_new ensures mode: "lines" wins even if caller passes something else
      fig = Express.line(@data, x: "x", y: "y", mode: "markers")
      [trace] = fig.data
      assert trace.mode == "lines"
    end
  end

  describe "histogram/2" do
    test "returns a Figure" do
      fig = Express.histogram(@data, x: "x")
      assert %Figure{} = fig
    end

    test "produces one Histogram trace" do
      fig = Express.histogram(@data, x: "x")
      assert [%Histogram{}] = fig.data
    end

    test "trace has x field populated" do
      fig = Express.histogram(@data, x: "x")
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
    end

    test "raises KeyError when :x is missing" do
      assert_raise KeyError, fn -> Express.histogram(@data, []) end
    end
  end

  describe "box/2" do
    @box_data [
      %{"cat" => "a", "val" => 1},
      %{"cat" => "a", "val" => 2},
      %{"cat" => "b", "val" => 3}
    ]

    test "returns a Figure" do
      fig = Express.box(@box_data, x: "cat", y: "val")
      assert %Figure{} = fig
    end

    test "produces one Box trace" do
      fig = Express.box(@box_data, x: "cat", y: "val")
      assert [%Box{}] = fig.data
    end

    test "trace has x and y populated" do
      fig = Express.box(@box_data, x: "cat", y: "val")
      [trace] = fig.data
      assert trace.x == ["a", "a", "b"]
      assert trace.y == [1, 2, 3]
    end

    test "raises KeyError when :x is missing" do
      assert_raise KeyError, fn -> Express.box(@box_data, y: "val") end
    end

    test "raises KeyError when :y is missing" do
      assert_raise KeyError, fn -> Express.box(@box_data, x: "cat") end
    end
  end

  describe "pie/2" do
    @pie_data [
      %{"amount" => 10, "slice" => "A"},
      %{"amount" => 20, "slice" => "B"}
    ]

    test "returns a Figure" do
      fig = Express.pie(@pie_data, values: "amount")
      assert %Figure{} = fig
    end

    test "produces one Pie trace" do
      fig = Express.pie(@pie_data, values: "amount")
      assert [%Pie{}] = fig.data
    end

    test "trace has values populated" do
      fig = Express.pie(@pie_data, values: "amount")
      [trace] = fig.data
      assert trace.values == [10, 20]
    end

    test "trace has labels when names: is provided" do
      fig = Express.pie(@pie_data, values: "amount", names: "slice")
      [trace] = fig.data
      assert trace.labels == ["A", "B"]
    end

    test "trace has nil labels when names: is omitted" do
      fig = Express.pie(@pie_data, values: "amount")
      [trace] = fig.data
      assert is_nil(trace.labels)
    end

    test "raises KeyError when :values is missing" do
      assert_raise KeyError, fn -> Express.pie(@pie_data, []) end
    end
  end

  @ohlc_data [
    %{"date" => "2024-01-01", "open" => 100.0, "high" => 110.0, "low" => 95.0, "close" => 105.0},
    %{"date" => "2024-01-02", "open" => 105.0, "high" => 115.0, "low" => 102.0, "close" => 108.0}
  ]

  @hierarchy_data [
    %{"name" => "Root", "parent" => "", "value" => 100},
    %{"name" => "A", "parent" => "Root", "value" => 60},
    %{"name" => "B", "parent" => "Root", "value" => 40}
  ]

  describe "violin/2" do
    test "returns a Figure" do
      fig = Express.violin(@data, x: "x", y: "y")
      assert %Figure{} = fig
    end

    test "produces one Violin trace" do
      fig = Express.violin(@data, x: "x", y: "y")
      assert [%Violin{}] = fig.data
    end

    test "trace has x and y populated" do
      fig = Express.violin(@data, x: "x", y: "y")
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, 5, 6]
    end

    test "raises KeyError when :x is missing" do
      assert_raise KeyError, fn -> Express.violin(@data, y: "y") end
    end

    test "raises KeyError when :y is missing" do
      assert_raise KeyError, fn -> Express.violin(@data, x: "x") end
    end
  end

  describe "candlestick/2" do
    test "returns a Figure" do
      fig =
        Express.candlestick(@ohlc_data,
          x: "date",
          open: "open",
          high: "high",
          low: "low",
          close: "close"
        )

      assert %Figure{} = fig
    end

    test "produces one Candlestick trace" do
      fig =
        Express.candlestick(@ohlc_data,
          x: "date",
          open: "open",
          high: "high",
          low: "low",
          close: "close"
        )

      assert [%Candlestick{}] = fig.data
    end

    test "trace has all OHLC columns populated" do
      fig =
        Express.candlestick(@ohlc_data,
          x: "date",
          open: "open",
          high: "high",
          low: "low",
          close: "close"
        )

      [trace] = fig.data
      assert trace.x == ["2024-01-01", "2024-01-02"]
      assert trace.open == [100.0, 105.0]
      assert trace.high == [110.0, 115.0]
      assert trace.low == [95.0, 102.0]
      assert trace.close == [105.0, 108.0]
    end

    test "raises KeyError when :open is missing" do
      assert_raise KeyError, fn ->
        Express.candlestick(@ohlc_data, x: "date", high: "high", low: "low", close: "close")
      end
    end
  end

  describe "ohlc/2" do
    test "produces one Ohlc trace" do
      fig =
        Express.ohlc(@ohlc_data,
          x: "date",
          open: "open",
          high: "high",
          low: "low",
          close: "close"
        )

      assert [%Ohlc{}] = fig.data
    end

    test "trace has all OHLC columns populated" do
      fig =
        Express.ohlc(@ohlc_data,
          x: "date",
          open: "open",
          high: "high",
          low: "low",
          close: "close"
        )

      [trace] = fig.data
      assert trace.x == ["2024-01-01", "2024-01-02"]
      assert trace.open == [100.0, 105.0]
      assert trace.high == [110.0, 115.0]
      assert trace.low == [95.0, 102.0]
      assert trace.close == [105.0, 108.0]
    end
  end

  describe "waterfall/2" do
    @wf_data [
      %{"item" => "Start", "amount" => 1000},
      %{"item" => "Revenue", "amount" => 500},
      %{"item" => "Costs", "amount" => -200},
      %{"item" => "Net", "amount" => 0}
    ]

    test "returns a Figure" do
      fig = Express.waterfall(@wf_data, x: "item", y: "amount")
      assert %Figure{} = fig
    end

    test "produces one Waterfall trace" do
      fig = Express.waterfall(@wf_data, x: "item", y: "amount")
      assert [%Waterfall{}] = fig.data
    end

    test "trace has x and y populated" do
      fig = Express.waterfall(@wf_data, x: "item", y: "amount")
      [trace] = fig.data
      assert trace.x == ["Start", "Revenue", "Costs", "Net"]
      assert trace.y == [1000, 500, -200, 0]
    end

    test "explicit measure: list passes through to trace" do
      measures = ["absolute", "relative", "relative", "total"]
      fig = Express.waterfall(@wf_data, x: "item", y: "amount", measure: measures)
      [trace] = fig.data
      assert trace.measure == measures
    end
  end

  describe "sunburst/2" do
    test "returns a Figure" do
      fig = Express.sunburst(@hierarchy_data, labels: "name", parents: "parent")
      assert %Figure{} = fig
    end

    test "produces one Sunburst trace" do
      fig = Express.sunburst(@hierarchy_data, labels: "name", parents: "parent")
      assert [%Sunburst{}] = fig.data
    end

    test "trace has labels and parents populated" do
      fig = Express.sunburst(@hierarchy_data, labels: "name", parents: "parent")
      [trace] = fig.data
      assert trace.labels == ["Root", "A", "B"]
      assert trace.parents == ["", "Root", "Root"]
    end

    test "trace has values when values: is provided" do
      fig =
        Express.sunburst(@hierarchy_data, labels: "name", parents: "parent", values: "value")

      [trace] = fig.data
      assert trace.values == [100, 60, 40]
    end

    test "trace has nil values when values: is omitted" do
      fig = Express.sunburst(@hierarchy_data, labels: "name", parents: "parent")
      [trace] = fig.data
      assert is_nil(trace.values)
    end

    test "raises KeyError when :labels is missing" do
      assert_raise KeyError, fn ->
        Express.sunburst(@hierarchy_data, parents: "parent")
      end
    end

    test "raises KeyError when :parents is missing" do
      assert_raise KeyError, fn ->
        Express.sunburst(@hierarchy_data, labels: "name")
      end
    end
  end

  describe "treemap/2" do
    test "produces one Treemap trace" do
      fig = Express.treemap(@hierarchy_data, labels: "name", parents: "parent")
      assert [%Treemap{}] = fig.data
    end

    test "trace has labels and parents populated" do
      fig = Express.treemap(@hierarchy_data, labels: "name", parents: "parent")
      [trace] = fig.data
      assert trace.labels == ["Root", "A", "B"]
      assert trace.parents == ["", "Root", "Root"]
    end

    test "trace has values when values: is provided" do
      fig =
        Express.treemap(@hierarchy_data, labels: "name", parents: "parent", values: "value")

      [trace] = fig.data
      assert trace.values == [100, 60, 40]
    end
  end

  describe "scatter3d/2" do
    @data_3d [
      %{"x" => 1.0, "y" => 2.0, "z" => 3.0},
      %{"x" => 4.0, "y" => 5.0, "z" => 6.0}
    ]

    test "returns a Figure" do
      fig = Express.scatter3d(@data_3d, x: "x", y: "y", z: "z")
      assert %Figure{} = fig
    end

    test "produces one Scatter3d trace" do
      fig = Express.scatter3d(@data_3d, x: "x", y: "y", z: "z")
      assert [%Scatter3d{}] = fig.data
    end

    test "trace has x, y, z populated" do
      fig = Express.scatter3d(@data_3d, x: "x", y: "y", z: "z")
      [trace] = fig.data
      assert trace.x == [1.0, 4.0]
      assert trace.y == [2.0, 5.0]
      assert trace.z == [3.0, 6.0]
    end

    test "raises KeyError when :z is missing" do
      assert_raise KeyError, fn ->
        Express.scatter3d(@data_3d, x: "x", y: "y")
      end
    end
  end

  @geo_data [
    %{"city" => "London", "lat" => 51.5, "lon" => -0.1},
    %{"city" => "Paris", "lat" => 48.85, "lon" => 2.35}
  ]

  @choropleth_data [
    %{"code" => "GBR", "value" => 67_000_000},
    %{"code" => "FRA", "value" => 68_000_000}
  ]

  describe "scattergeo/2" do
    test "returns a Figure" do
      fig = Express.scattergeo(@geo_data, lat: "lat", lon: "lon")
      assert %Figure{} = fig
    end

    test "produces one Scattergeo trace" do
      fig = Express.scattergeo(@geo_data, lat: "lat", lon: "lon")
      assert [%Scattergeo{}] = fig.data
    end

    test "trace has lat and lon populated" do
      fig = Express.scattergeo(@geo_data, lat: "lat", lon: "lon")
      [trace] = fig.data
      assert trace.lat == [51.5, 48.85]
      assert trace.lon == [-0.1, 2.35]
    end

    test "raises KeyError when :lat is missing" do
      assert_raise KeyError, fn -> Express.scattergeo(@geo_data, lon: "lon") end
    end

    test "raises KeyError when :lon is missing" do
      assert_raise KeyError, fn -> Express.scattergeo(@geo_data, lat: "lat") end
    end
  end

  describe "choropleth/2" do
    test "returns a Figure" do
      fig = Express.choropleth(@choropleth_data, locations: "code", z: "value")
      assert %Figure{} = fig
    end

    test "produces one Choropleth trace" do
      fig = Express.choropleth(@choropleth_data, locations: "code", z: "value")
      assert [%Choropleth{}] = fig.data
    end

    test "trace has locations and z populated" do
      fig = Express.choropleth(@choropleth_data, locations: "code", z: "value")
      [trace] = fig.data
      assert trace.locations == ["GBR", "FRA"]
      assert trace.z == [67_000_000, 68_000_000]
    end

    test "locationmode defaults to \"ISO-3\" when not provided" do
      fig = Express.choropleth(@choropleth_data, locations: "code", z: "value")
      [trace] = fig.data
      assert trace.locationmode == "ISO-3"
    end

    test "caller-supplied locationmode overrides default" do
      fig =
        Express.choropleth(@choropleth_data,
          locations: "code",
          z: "value",
          locationmode: "country names"
        )

      [trace] = fig.data
      assert trace.locationmode == "country names"
    end

    test "raises KeyError when :locations is missing" do
      assert_raise KeyError, fn -> Express.choropleth(@choropleth_data, z: "value") end
    end

    test "raises KeyError when :z is missing" do
      assert_raise KeyError, fn -> Express.choropleth(@choropleth_data, locations: "code") end
    end
  end

  describe "scattermap/2" do
    test "returns a Figure" do
      fig = Express.scattermap(@geo_data, lat: "lat", lon: "lon")
      assert %Figure{} = fig
    end

    test "produces one Scattermap trace" do
      fig = Express.scattermap(@geo_data, lat: "lat", lon: "lon")
      assert [%Scattermap{}] = fig.data
    end

    test "trace has lat and lon populated" do
      fig = Express.scattermap(@geo_data, lat: "lat", lon: "lon")
      [trace] = fig.data
      assert trace.lat == [51.5, 48.85]
      assert trace.lon == [-0.1, 2.35]
    end

    test "layout has default open-street-map style" do
      fig = Express.scattermap(@geo_data, lat: "lat", lon: "lon")
      assert fig.layout.map == %{style: "open-street-map"}
    end

    test "raises KeyError when :lat is missing" do
      assert_raise KeyError, fn -> Express.scattermap(@geo_data, lon: "lon") end
    end

    test "raises KeyError when :lon is missing" do
      assert_raise KeyError, fn -> Express.scattermap(@geo_data, lat: "lat") end
    end
  end

  describe "scatterpolar/2" do
    test "creates Figure with one Scatterpolar trace, r and theta populated" do
      fig = Express.scatterpolar(@polar_data, r: "r", theta: "theta")
      assert [%Scatterpolar{r: [1.5, 2.0, 0.5], theta: [45, 90, 135]}] = fig.data
    end

    test "extra opts pass through to trace" do
      fig = Express.scatterpolar(@polar_data, r: "r", theta: "theta", mode: "markers")
      assert [%Scatterpolar{mode: "markers"}] = fig.data
    end

    test "raises KeyError when :r is missing" do
      assert_raise KeyError, fn -> Express.scatterpolar(@polar_data, theta: "theta") end
    end

    test "raises KeyError when :theta is missing" do
      assert_raise KeyError, fn -> Express.scatterpolar(@polar_data, r: "r") end
    end
  end

  describe "indicator/2" do
    test "creates Figure with one Indicator trace, value is first element" do
      fig = Express.indicator(@kpi_data, value: "value")
      assert [%Indicator{value: 347}] = fig.data
    end

    test "extra opts pass through to trace (mode, title)" do
      fig = Express.indicator(@kpi_data, value: "value", mode: "number+delta")
      assert [%Indicator{mode: "number+delta"}] = fig.data
    end

    test "raises KeyError when :value is missing" do
      assert_raise KeyError, fn -> Express.indicator(@kpi_data, []) end
    end
  end

  describe "histogram2d/2" do
    test "creates Figure with one Histogram2d trace, x and y populated" do
      fig = Express.histogram2d(@data, x: "x", y: "y")
      assert [%Histogram2d{x: [1, 2, 3], y: [4, 5, 6]}] = fig.data
    end

    test "extra opts pass through to trace" do
      fig = Express.histogram2d(@data, x: "x", y: "y", nbinsx: 10)
      assert [%Histogram2d{nbinsx: 10}] = fig.data
    end
  end

  describe "barpolar/2" do
    test "creates Figure with one Barpolar trace, r and theta populated" do
      fig = Express.barpolar(@polar_data, r: "r", theta: "theta")
      assert [%Barpolar{r: [1.5, 2.0, 0.5], theta: [45, 90, 135]}] = fig.data
    end

    test "extra opts pass through to trace" do
      fig = Express.barpolar(@polar_data, r: "r", theta: "theta", name: "Wind")
      assert [%Barpolar{name: "Wind"}] = fig.data
    end
  end

  describe "funnel/2" do
    test "creates Figure with one Funnel trace, x and y populated" do
      fig = Express.funnel(@data, x: "x", y: "y")
      assert [%Funnel{x: [1, 2, 3], y: [4, 5, 6]}] = fig.data
    end

    test "extra opts pass through to trace" do
      fig = Express.funnel(@data, x: "x", y: "y", name: "Sales")
      assert [%Funnel{name: "Sales"}] = fig.data
    end
  end

  describe "keyword list rows — string column names" do
    test "histogram/2 with keyword list rows and string col name" do
      fig = Express.histogram(@kw_hist_data, x: "height")
      assert [%Histogram{x: [163, 170, 175]}] = fig.data
    end

    test "box/2 with keyword list rows and string col names" do
      fig = Express.box(@kw_box_data, x: "group", y: "score")
      [trace] = fig.data
      assert trace.x == ["A", "A", "B"]
      assert trace.y == [72, 85, 55]
    end

    test "scatter/2 with keyword list rows and string col names" do
      fig = Express.scatter(@kw_data, x: "x", y: "y")
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, 5, 6]
    end

    test "scatter/2 color grouping with keyword list rows and string col names" do
      fig = Express.scatter(@kw_data, x: "x", y: "y", color: "cat")
      assert length(fig.data) == 2
      names = fig.data |> Enum.map(& &1.name) |> Enum.sort()
      assert names == ["a", "b"]
    end
  end

  describe "keyword list rows — atom column names" do
    test "histogram/2 with keyword list rows and atom col name" do
      fig = Express.histogram(@kw_hist_data, x: :height)
      assert [%Histogram{x: [163, 170, 175]}] = fig.data
    end

    test "box/2 with keyword list rows and atom col names" do
      fig = Express.box(@kw_box_data, x: :group, y: :score)
      [trace] = fig.data
      assert trace.x == ["A", "A", "B"]
      assert trace.y == [72, 85, 55]
    end

    test "scatter/2 with keyword list rows and atom col names" do
      fig = Express.scatter(@kw_data, x: :x, y: :y)
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, 5, 6]
    end
  end

  describe "string-keyed map rows — atom column names (regression)" do
    test "scatter/2 with map rows and atom col names" do
      fig = Express.scatter(@data, x: :x, y: :y)
      [trace] = fig.data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, 5, 6]
    end

    test "histogram/2 with map rows and atom col name" do
      data = [%{"height" => 163}, %{"height" => 170}]
      fig = Express.histogram(data, x: :height)
      assert [%Histogram{x: [163, 170]}] = fig.data
    end
  end
end

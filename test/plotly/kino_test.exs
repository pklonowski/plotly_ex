defmodule Plotly.KinoTest do
  use ExUnit.Case, async: true
  @moduletag :requires_kino

  alias Plotly.Figure

  # Retrieve the raw payload string stored by Kino.JS.DataStore for a widget ref.
  defp get_static_payload(widget) do
    state = :sys.get_state(Kino.JS.DataStore)
    state.ref_with_data[widget.ref].data
  end

  describe "PlotlyStatic.new/1" do
    test "returns a Kino.JS struct without raising" do
      fig = Figure.new(data: [Plotly.Scatter.new(x: [1, 2], y: [3, 4])])
      widget = Plotly.Kino.PlotlyStatic.new(fig)
      assert is_struct(widget, Kino.JS)
    end

    test "widget payload is valid JSON containing figureJson and plotlyUrls" do
      fig = Figure.new()
      widget = Plotly.Kino.PlotlyStatic.new(fig)
      payload = Jason.decode!(get_static_payload(widget))
      assert Map.has_key?(payload, "figureJson")
      assert is_list(payload["plotlyUrls"])
      assert "https://cdn.plot.ly/plotly-4.1.2.min.js" in payload["plotlyUrls"]
      # local bundle is the final fallback
      assert List.last(payload["plotlyUrls"]) =~ "plotly.min.js"
    end

    test "figureJson round-trips back to the original figure structure" do
      fig = Figure.new(layout: %{title: "Test"})
      widget = Plotly.Kino.PlotlyStatic.new(fig)
      payload = Jason.decode!(get_static_payload(widget))
      decoded = Jason.decode!(payload["figureJson"])
      assert decoded["layout"]["title"] == "Test"
      assert decoded["config"]["showSendToCloud"] == false
    end

    test "plotlyUrls is a non-empty list ending in the bundled fallback" do
      widget = Plotly.Kino.PlotlyStatic.new(Figure.new())
      payload = Jason.decode!(get_static_payload(widget))
      assert payload["plotlyUrls"] != []
      assert List.last(payload["plotlyUrls"]) == "./plotly.min.js"
    end
  end

  describe "PlotlyLive.new/1 and push/2" do
    test "returns a struct without raising" do
      fig = Figure.new()
      widget = Plotly.Kino.PlotlyLive.new(fig)
      assert is_struct(widget)
    end

    test "push/2 does not raise on a valid figure" do
      fig = Figure.new()
      widget = Plotly.Kino.PlotlyLive.new(fig)
      assert :ok = Plotly.Kino.PlotlyLive.push(widget, Figure.new(layout: %{title: "Updated"}))
    end
  end

  describe "PlotlyLive render config" do
    import Kino.Test
    setup :configure_livebook_bridge

    test "connect, push, and reconnect preserve render defaults and explicit Cloud opt-in" do
      chart = Plotly.Kino.PlotlyLive.new(Figure.new())
      payload = chart |> connect() |> Jason.decode!()
      assert Jason.decode!(payload["figureJson"])["config"]["showSendToCloud"] == false

      Plotly.Kino.PlotlyLive.push(chart, Figure.new(layout: %{title: "updated"}))
      assert_broadcast_event(chart, "update", update)
      assert Jason.decode!(update)["config"]["showSendToCloud"] == false

      Plotly.Kino.PlotlyLive.push(chart, Figure.new(config: %{showSendToCloud: true}))
      assert_broadcast_event(chart, "update", update)
      assert Jason.decode!(update)["config"]["showSendToCloud"] == true
      payload = chart |> connect() |> Jason.decode!()
      assert Jason.decode!(payload["figureJson"])["config"]["showSendToCloud"] == true
    end
  end

  describe "PlotlyLive.subscribe/2 and event dispatch" do
    test "unhover filter forwards only unhover and rejects unknown filters" do
      chart = Plotly.Kino.PlotlyLive.new(Figure.new())
      Plotly.Kino.PlotlyLive.subscribe(chart, :unhover, :unhover)
      Plotly.Kino.PlotlyLive.subscribe(chart, :click_only, :click)
      Plotly.Kino.PlotlyLive.dispatch_event(chart, %{"type" => "plotly_unhover", "data" => %{}})
      assert_receive {:unhover, %{"type" => "plotly_unhover"}}
      refute_receive {:click_only, _}
      assert_raise KeyError, fn -> Plotly.Kino.PlotlyLive.subscribe(chart, :bad, :unknown) end
    end

    test "subscribe/2 returns :ok without raising" do
      chart = Plotly.Kino.PlotlyLive.new(Figure.new())
      assert :ok == Plotly.Kino.PlotlyLive.subscribe(chart, :events)
    end

    test "subscribed process receives dispatched event under its tag" do
      chart = Plotly.Kino.PlotlyLive.new(Figure.new())
      Plotly.Kino.PlotlyLive.subscribe(chart, :my_events)
      Plotly.Kino.PlotlyLive.dispatch_event(chart, %{"type" => "click", "points" => []})
      assert_receive {:my_events, %{"type" => "click"}}
    end

    test "subscribe/3 with explicit pid forwards to that pid" do
      chart = Plotly.Kino.PlotlyLive.new(Figure.new())
      Plotly.Kino.PlotlyLive.subscribe(chart, self(), :forwarded)
      Plotly.Kino.PlotlyLive.dispatch_event(chart, %{"type" => "hover"})
      assert_receive {:forwarded, %{"type" => "hover"}}
    end

    test "multiple subscribers each receive the same event" do
      chart = Plotly.Kino.PlotlyLive.new(Figure.new())
      Plotly.Kino.PlotlyLive.subscribe(chart, :sub1)
      Plotly.Kino.PlotlyLive.subscribe(chart, :sub2)
      Plotly.Kino.PlotlyLive.dispatch_event(chart, %{"type" => "zoom"})
      assert_receive {:sub1, %{"type" => "zoom"}}
      assert_receive {:sub2, %{"type" => "zoom"}}
    end
  end

  describe "SmartCell state model" do
    test "init/2 builds layers and global assigns from new-format attrs" do
      attrs = %{
        "layers" => [
          %{
            "id" => "1",
            "chart_type" => "scatter",
            "data_variable" => "df",
            "x_field" => "date",
            "y_field" => "price",
            "color_field" => ""
          }
        ],
        "title" => "My Chart",
        "width" => "",
        "height" => ""
      }

      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(attrs, Kino.JS.Live.Context.new())
      assert [layer] = ctx.assigns.layers
      assert layer["chart_type"] == "scatter"
      assert layer["data_variable"] == "df"
      assert ctx.assigns.global["title"] == "My Chart"
    end

    test "init/2 migrates old flat attrs (pre-layers format)" do
      old_attrs = %{
        "chart_type" => "bar",
        "data_variable" => "my_df",
        "x_field" => "month",
        "y_field" => "sales",
        "color_field" => "region",
        "title" => "Revenue",
        "width" => "",
        "height" => ""
      }

      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(old_attrs, Kino.JS.Live.Context.new())
      assert [layer] = ctx.assigns.layers
      assert layer["chart_type"] == "bar"
      assert layer["data_variable"] == "my_df"
      assert layer["x_field"] == "month"
      assert layer["color_field"] == "region"
      assert ctx.assigns.global["title"] == "Revenue"
    end

    test "init/2 migrates very old field names (variable/x/y/color)" do
      old_attrs = %{
        "chart_type" => "bar",
        "variable" => "my_df",
        "x" => "date",
        "y" => "sales",
        "color" => "region"
      }

      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(old_attrs, Kino.JS.Live.Context.new())
      assert [layer] = ctx.assigns.layers
      assert layer["data_variable"] == "my_df"
      assert layer["x_field"] == "date"
    end

    test "init/2 defaults to one empty scatter layer when attrs are empty" do
      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(%{}, Kino.JS.Live.Context.new())
      assert [layer] = ctx.assigns.layers
      assert layer["chart_type"] == "scatter"
      assert layer["data_variable"] == ""
      assert layer["u_field"] == ""
      assert layer["v_field"] == ""
    end

    test "to_attrs/1 serialises layers and global fields" do
      attrs = %{
        "layers" => [
          %{
            "id" => "1",
            "chart_type" => "scatter",
            "data_variable" => "df",
            "x_field" => "x",
            "y_field" => "y",
            "color_field" => ""
          }
        ],
        "title" => "",
        "width" => "",
        "height" => ""
      }

      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(attrs, Kino.JS.Live.Context.new())
      result = Plotly.Kino.SmartCell.to_attrs(ctx)
      assert is_list(result["layers"])
      assert Map.has_key?(result, "title")
      assert Map.has_key?(result, "width")
      assert Map.has_key?(result, "height")
    end
  end

  describe "SmartCell quiver controls" do
    import Kino.Test
    setup :configure_livebook_bridge

    test "layer update events preserve both vector selections" do
      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(%{}, Kino.JS.Live.Context.new())
      [layer] = ctx.assigns.layers

      ctx = %{ctx | __private__: %{ref: "quiver-test"}}

      ctx =
        Enum.reduce(~w(u_field v_field), ctx, fn field, ctx ->
          {:noreply, updated} =
            Plotly.Kino.SmartCell.handle_event(
              "update_layer",
              %{"id" => layer["id"], "field" => field, "value" => field},
              ctx
            )

          updated
        end)

      assert [updated] = ctx.assigns.layers
      assert updated["u_field"] == "u_field"
      assert updated["v_field"] == "v_field"
    end

    test "UI offers quiver and renders vector selectors conditionally" do
      source = File.read!("lib/plotly/kino/smart_cell.ex")
      assert source =~ ~s|"pie", "quiver"|
      assert source =~ ~s|layer.chart_type === "quiver"|
      assert source =~ ~s|columnSelect(layer, "u_field", "U vector", cols)|
      assert source =~ ~s|columnSelect(layer, "v_field", "V vector", cols)|
    end
  end

  describe "SmartCell.to_source/1" do
    defp layer(overrides \\ %{}) do
      Map.merge(
        %{
          "id" => "1",
          "chart_type" => "scatter",
          "data_variable" => "df",
          "x_field" => "date",
          "y_field" => "price",
          "color_field" => ""
        },
        overrides
      )
    end

    defp attrs(layers, global \\ %{}) do
      Map.merge(%{"layers" => layers, "title" => "", "width" => "", "height" => ""}, global)
    end

    defp quiver_layer(overrides \\ %{}) do
      layer(
        Map.merge(
          %{
            "chart_type" => "quiver",
            "data_variable" => "field",
            "x_field" => "x",
            "y_field" => "y",
            "u_field" => "u",
            "v_field" => "v"
          },
          overrides
        )
      )
    end

    test "quiver emits all four vector column selectors" do
      assert Plotly.Kino.SmartCell.to_source(attrs([quiver_layer()])) ==
               ~s[Plotly.quiver(field, x: "x", y: "y", u: "u", v: "v") |> Plotly.show()]
    end

    test "quiver requires every vector selector and a valid variable" do
      for field <- ~w(x_field y_field u_field v_field data_variable) do
        assert Plotly.Kino.SmartCell.to_source(attrs([quiver_layer(%{field => ""})])) ==
                 "# Select a variable and chart type"
      end
    end

    test "stored vector selectors are ignored for scatter" do
      assert Plotly.Kino.SmartCell.to_source(
               attrs([layer(%{"u_field" => "u", "v_field" => "v"})])
             ) ==
               ~s[Plotly.scatter(df, x: "date", y: "price") |> Plotly.show()]
    end

    test "quiver column names preserve special characters as literal strings" do
      for {field, option} <- [{"u_field", :u}, {"v_field", :v}],
          column <- [~S(u"name), ~S(u\name), ~S(#{velocity})] do
        source = Plotly.Kino.SmartCell.to_source(attrs([quiver_layer(%{field => column})]))

        assert {:ok, {:|>, _, [{{:., _, [_, :quiver]}, _, [_variable, opts]}, _]}} =
                 Code.string_to_quoted(source)

        assert opts[option] == column
      end
    end

    test "long column names remain complete literal strings in generated source" do
      column = String.duplicate("a", 4097) <> "_tail"

      for {field, option} <- [
            {"x_field", :x},
            {"y_field", :y},
            {"u_field", :u},
            {"v_field", :v},
            {"color_field", :color}
          ] do
        source = Plotly.Kino.SmartCell.to_source(attrs([quiver_layer(%{field => column})]))

        assert {:ok, {:|>, _, [{{:., _, [_, :quiver]}, _, [_variable, opts]}, _]}} =
                 Code.string_to_quoted(source)

        assert is_binary(opts[option]), "long #{option} must remain a string literal"
        assert opts[option] == column
      end
    end

    test "long chart titles remain complete literal strings in generated source" do
      title = String.duplicate("a", 4097) <> "_tail"
      source = Plotly.Kino.SmartCell.to_source(attrs([layer()], %{"title" => title}))

      assert {:ok, {:|>, _, [{{:., _, [_, :scatter]}, _, [_variable, opts]}, _]}} =
               Code.string_to_quoted(source)

      assert is_binary(opts[:title]), "long title must remain a string literal"
      assert opts[:title] == title
    end

    test "saved scatter layers gain vector defaults without source changes" do
      old = attrs([layer()])
      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(old, Kino.JS.Live.Context.new())
      [saved] = ctx.assigns.layers
      assert saved["u_field"] == ""
      assert saved["v_field"] == ""

      assert Plotly.Kino.SmartCell.to_source(Plotly.Kino.SmartCell.to_attrs(ctx)) ==
               ~s[Plotly.scatter(df, x: "date", y: "price") |> Plotly.show()]
    end

    test "flat quiver attrs preserve vector selectors through migration" do
      {:ok, ctx, _} = Plotly.Kino.SmartCell.init(quiver_layer(), Kino.JS.Live.Context.new())
      assert [saved] = ctx.assigns.layers
      assert saved["u_field"] == "u"
      assert saved["v_field"] == "v"
    end

    test "single layer generates Express call with Plotly.show()" do
      source = Plotly.Kino.SmartCell.to_source(attrs([layer()]))
      assert source =~ ~s[Plotly.scatter(df, x: "date", y: "price")]
      assert source =~ "|> Plotly.show()"
    end

    test "single layer with color includes color opt" do
      source = Plotly.Kino.SmartCell.to_source(attrs([layer(%{"color_field" => "cat"})]))
      assert source =~ ~s[color: "cat"]
    end

    test "single layer with global title includes title opt" do
      source = Plotly.Kino.SmartCell.to_source(attrs([layer()], %{"title" => "Revenue"}))
      assert source =~ ~s[title: "Revenue"]
    end

    test "two valid layers generates Figure.merge pipe" do
      layers = [
        layer(%{
          "chart_type" => "scatter",
          "data_variable" => "df",
          "x_field" => "x",
          "y_field" => "y"
        }),
        %{
          "id" => "2",
          "chart_type" => "bar",
          "data_variable" => "other",
          "x_field" => "name",
          "y_field" => "count",
          "color_field" => ""
        }
      ]

      source = Plotly.Kino.SmartCell.to_source(attrs(layers))
      assert source =~ "Plotly.scatter(df"
      assert source =~ "|> Plotly.Figure.merge(Plotly.bar(other"
      assert source =~ "|> Plotly.show()"
    end

    test "invalid layer (bad variable) is skipped silently" do
      layers = [
        layer(%{"data_variable" => "bad-var!"}),
        %{
          "id" => "2",
          "chart_type" => "bar",
          "data_variable" => "good",
          "x_field" => "x",
          "y_field" => "y",
          "color_field" => ""
        }
      ]

      source = Plotly.Kino.SmartCell.to_source(attrs(layers))
      assert source =~ "Plotly.bar(good"
      refute source =~ "bad-var!"
    end

    test "no valid layers returns a comment" do
      source = Plotly.Kino.SmartCell.to_source(attrs([layer(%{"data_variable" => ""})]))
      assert String.starts_with?(source, "#")
    end

    test "column names preserve literal backslashes and interpolation in generated AST" do
      for column <- [~S(path\name), ~S(#{danger})] do
        source = Plotly.Kino.SmartCell.to_source(attrs([layer(%{"x_field" => column})]))

        assert {:ok, {:|>, _, [{{:., _, [_, :scatter]}, _, [_variable, opts]}, _]}} =
                 Code.string_to_quoted(source)

        assert opts[:x] == column
      end
    end

    test "escapes double quotes in column names" do
      source = Plotly.Kino.SmartCell.to_source(attrs([layer(%{"x_field" => ~s[col"name]})]))
      refute source =~ ~s[x: "col"name"]
      assert source =~ ~s[col\\"name]
    end

    test "three valid layers generates correct merge chain" do
      layers = [
        layer(%{
          "chart_type" => "scatter",
          "data_variable" => "df1",
          "x_field" => "x",
          "y_field" => "y"
        }),
        %{
          "id" => "2",
          "chart_type" => "bar",
          "data_variable" => "df2",
          "x_field" => "a",
          "y_field" => "b",
          "color_field" => ""
        },
        %{
          "id" => "3",
          "chart_type" => "line",
          "data_variable" => "df3",
          "x_field" => "p",
          "y_field" => "q",
          "color_field" => ""
        }
      ]

      source = Plotly.Kino.SmartCell.to_source(attrs(layers))
      assert source =~ "Plotly.scatter(df1"
      assert source =~ "|> Plotly.Figure.merge(Plotly.bar(df2"
      assert source =~ "|> Plotly.Figure.merge(Plotly.line(df3"
      assert source =~ "|> Plotly.show()"
    end

    test "first layer invalid, two remaining valid produces multi-layer source" do
      layers = [
        layer(%{"data_variable" => "bad var!"}),
        %{
          "id" => "2",
          "chart_type" => "scatter",
          "data_variable" => "df1",
          "x_field" => "x",
          "y_field" => "y",
          "color_field" => ""
        },
        %{
          "id" => "3",
          "chart_type" => "bar",
          "data_variable" => "df2",
          "x_field" => "a",
          "y_field" => "b",
          "color_field" => ""
        }
      ]

      source = Plotly.Kino.SmartCell.to_source(attrs(layers))
      assert source =~ "Plotly.scatter(df1"
      assert source =~ "|> Plotly.Figure.merge(Plotly.bar(df2"
      refute source =~ "bad var!"
    end

    test "global title only appears on first layer in multi-layer source" do
      layers = [
        layer(%{
          "chart_type" => "scatter",
          "data_variable" => "df1",
          "x_field" => "x",
          "y_field" => "y"
        }),
        %{
          "id" => "2",
          "chart_type" => "bar",
          "data_variable" => "df2",
          "x_field" => "a",
          "y_field" => "b",
          "color_field" => ""
        }
      ]

      source = Plotly.Kino.SmartCell.to_source(attrs(layers, %{"title" => "My Chart"}))
      [first_line | rest_lines] = String.split(source, "\n")
      assert first_line =~ ~s[title: "My Chart"]
      refute Enum.join(rest_lines) =~ ~s[title: "My Chart"]
    end
  end

  describe "SmartCell column discovery" do
    alias Plotly.Kino.SmartCell

    test "columns_for/1 returns columns for a list of string-keyed maps" do
      data = [%{"name" => "Alice", "age" => 30}, %{"name" => "Bob", "age" => 25}]
      cols = SmartCell.columns_for(data)
      assert is_list(cols)
      assert Enum.any?(cols, &(&1.name == "name"))
      assert Enum.any?(cols, &(&1.name == "age"))
    end

    test "columns_for/1 returns columns for a columnar map (map of lists)" do
      data = %{"x" => [1, 2, 3], "y" => [4, 5, 6]}
      cols = SmartCell.columns_for(data)
      assert is_list(cols)
      assert Enum.any?(cols, &(&1.name == "x"))
      assert Enum.any?(cols, &(&1.name == "y"))
    end

    @tag :requires_explorer
    test "columns_for/1 returns columns for an Explorer.DataFrame with mixed dtypes" do
      # Explorer 0.11 uses tuple dtypes like {:s, 64} for integers and {:f, 64} for floats.
      # to_string/1 raises on tuples — inspect/1 must be used instead.
      df =
        Explorer.DataFrame.new(%{
          "name" => ["Alice", "Bob"],
          "age" => [30, 25],
          "score" => [98.5, 72.3]
        })

      cols = SmartCell.columns_for(df)
      assert is_list(cols), "expected a list of columns, got: #{inspect(cols)}"
      col_names = Enum.map(cols, & &1.name)
      assert "name" in col_names
      assert "age" in col_names
      assert "score" in col_names
      assert Enum.all?(cols, &is_binary(&1.type))
    end

    @tag :requires_explorer
    test "scan_binding/3 discovers an Explorer.DataFrame variable" do
      df =
        Explorer.DataFrame.new(%{
          "city" => ["NYC", "LA"],
          "pop" => [8_000_000, 4_000_000]
        })

      SmartCell.scan_binding(self(), [my_df: df, irrelevant: 42], __ENV__)
      assert_receive {:scan_binding_result, data_options}
      var_names = Enum.map(data_options, & &1.variable)
      assert "my_df" in var_names
      refute "irrelevant" in var_names
    end

    test "columns_for/1 returns nil for non-tabular data" do
      assert SmartCell.columns_for(42) == nil
      assert SmartCell.columns_for("string") == nil
      assert SmartCell.columns_for([1, 2, 3]) == nil
      assert SmartCell.columns_for(%{}) == nil
    end

    test "scan_binding/3 sends :scan_binding_result with discovered variables" do
      binding = [
        df: [%{"col1" => 1, "col2" => "a"}, %{"col1" => 2, "col2" => "b"}],
        irrelevant: 42,
        columnar: %{"x" => [1, 2], "y" => [3, 4]}
      ]

      SmartCell.scan_binding(self(), binding, __ENV__)
      assert_receive {:scan_binding_result, data_options}
      assert length(data_options) == 2
      var_names = Enum.map(data_options, & &1.variable)
      assert "df" in var_names
      assert "columnar" in var_names
      refute "irrelevant" in var_names
    end
  end
end

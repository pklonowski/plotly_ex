defmodule Plotly.NamedTemplatesTest do
  use ExUnit.Case, async: true
  require Phoenix.LiveViewTest
  import ExUnit.CaptureLog

  alias Plotly.Figure

  test "render JSON expands a named template into concrete defaults without a browser registry" do
    figure = Plotly.scatter([%{"x" => 1, "y" => 2}], x: "x", y: "y", template: "plotly_dark")

    assert_dark_template(figure |> Figure.to_render_json() |> Jason.decode!())
  end

  test "string-keyed layouts resolve named templates too" do
    figure = Figure.new(layout: %{"template" => "plotly_dark"})

    assert_dark_template(figure |> Figure.to_render_json() |> Jason.decode!())
  end

  test "faithful JSON preserves the original named template" do
    figure = Figure.new(layout: %{template: "plotly_dark"})

    assert Jason.decode!(Figure.to_json(figure))["layout"]["template"] == "plotly_dark"
  end

  test "all bundled template names resolve, including an explicitly empty template" do
    for name <-
          ~w(ggplot2 gridon plotly plotly_dark plotly_white presentation seaborn simple_white xgridoff ygridoff none) do
      figure = Figure.new(layout: %{template: name})
      template = Jason.decode!(Figure.to_render_json(figure))["layout"]["template"]
      assert is_map(template), "unresolved template: #{name}"
      if name == "none", do: assert(template == %{}), else: assert(is_map(template["layout"]))
    end
  end

  test "an unknown name logs a warning and renders without a template" do
    figure = Figure.new(layout: %{template: "plotly_drak", title: "T"})
    assert Jason.decode!(Figure.to_json(figure))["layout"]["template"] == "plotly_drak"

    {json, log} = with_log(fn -> Figure.to_render_json(figure) end)

    assert log =~ ~r/unknown Plotly template.*plotly_drak.*plotly_dark/s
    layout = Jason.decode!(json)["layout"]
    assert layout["template"] == %{}
    assert layout["title"] == "T"
  end

  test "combined names merge left to right, later templates winning" do
    render = fn name ->
      Jason.decode!(Figure.to_render_json(Figure.new(layout: %{template: name})))["layout"][
        "template"
      ]
    end

    dark = render.("plotly_dark")
    ggplot = render.("ggplot2")
    pres = render.("presentation")
    assert dark["layout"]["paper_bgcolor"] != ggplot["layout"]["paper_bgcolor"]

    assert render.("plotly_dark+ggplot2")["layout"]["paper_bgcolor"] ==
             ggplot["layout"]["paper_bgcolor"]

    assert render.("ggplot2+plotly_dark")["layout"]["paper_bgcolor"] ==
             dark["layout"]["paper_bgcolor"]

    merged = render.("plotly_dark+presentation")
    # Keys from both sides survive the deep merge, including per-trace defaults.
    assert merged["layout"]["font"]["size"] == pres["layout"]["font"]["size"]
    assert merged["layout"]["font"]["color"] == dark["layout"]["font"]["color"]
    [scatter] = merged["data"]["scatter"]
    assert scatter["line"]["width"] == hd(pres["data"]["scatter"])["line"]["width"]
    assert scatter["marker"]["colorbar"] == hd(dark["data"]["scatter"])["marker"]["colorbar"]

    assert render.(:"plotly_dark+presentation") == merged
  end

  test "unknown parts of a combined name are skipped with a warning" do
    {json, log} =
      with_log(fn ->
        Figure.to_render_json(Figure.new(layout: %{template: "plotly_dark+nope+"}))
      end)

    assert log =~ ~r/unknown Plotly template.*"nope"/s
    template = Jason.decode!(json)["layout"]["template"]
    dark = Jason.decode!(Figure.to_render_json(Figure.new(layout: %{template: "plotly_dark"})))
    assert template == dark["layout"]["template"]
  end

  test "empty combination parts are ignored without warnings" do
    for name <- ["", "+", "+++", "++none++"] do
      {json, log} =
        with_log(fn -> Figure.to_render_json(Figure.new(layout: %{template: name})) end)

      assert Jason.decode!(json)["layout"]["template"] == %{}
      assert log == ""
    end
  end

  test "combined themes replace colorway and colorscale arrays as complete lists" do
    render = fn name ->
      Figure.new(layout: %{template: name})
      |> Figure.to_render_json()
      |> Jason.decode!()
      |> get_in(["layout", "template", "layout"])
    end

    for {first, last} <- [{"plotly_dark", "ggplot2"}, {"ggplot2", "plotly_dark"}] do
      expected = render.(last)
      combined = render.(first <> "+" <> last)
      assert is_list(expected["colorway"])
      assert is_list(expected["colorscale"]["sequential"])
      assert combined["colorway"] == expected["colorway"]

      for {kind, scale} <- expected["colorscale"] do
        assert combined["colorscale"][kind] == scale
      end

      # ggplot2 omits diverging: that setting must survive from plotly_dark.
      if last == "ggplot2" do
        assert combined["colorscale"]["diverging"] == render.(first)["colorscale"]["diverging"]
      end
    end
  end

  test "merge/2 rules: maps deep-merge, lists of maps merge per element, other values replace" do
    left = %{"a" => %{"b" => 1, "c" => 2}, "l" => [%{"x" => 1}, %{"y" => 2}], "s" => ["r", "g"]}
    right = %{"a" => %{"c" => 3}, "l" => [%{"z" => 3}], "s" => ["b"], "n" => 4}

    assert Plotly.Templates.merge(left, right) == %{
             "a" => %{"b" => 1, "c" => 3},
             "l" => [%{"x" => 1, "z" => 3}, %{"y" => 2}],
             "s" => ["b"],
             "n" => 4
           }

    assert Plotly.Templates.merge(%{"l" => [%{"x" => 1}]}, %{"l" => [%{}, %{"y" => 2}]}) ==
             %{"l" => [%{"x" => 1}, %{"y" => 2}]}
  end

  test "atom template names resolve exactly like the equivalent string" do
    for name <- [:plotly_dark, :ggplot2, :none] do
      from_atom = Jason.decode!(Figure.to_render_json(Figure.new(layout: %{template: name})))

      from_string =
        Jason.decode!(
          Figure.to_render_json(Figure.new(layout: %{template: Atom.to_string(name)}))
        )

      assert is_map(from_atom["layout"]["template"]),
             "unresolved atom template #{inspect(name)}: #{inspect(from_atom["layout"]["template"])}"

      assert from_atom["layout"]["template"] == from_string["layout"]["template"]
    end

    assert_dark_template(
      Figure.new(layout: %{template: :plotly_dark})
      |> Figure.to_render_json()
      |> Jason.decode!()
    )
  end

  test "an unknown atom template name logs a warning and renders without a template" do
    figure = Figure.new(layout: %{template: :no_such_template})

    {json, log} = with_log(fn -> Figure.to_render_json(figure) end)

    assert log =~ ~r/unknown Plotly template.*no_such_template/s
    assert Jason.decode!(json)["layout"]["template"] == %{}
  end

  test "nil and boolean templates are preserved without name warnings" do
    for template <- [nil, true, false] do
      figure = Figure.new(layout: %{template: template})
      {json, log} = with_log(fn -> Figure.to_render_json(figure) end)
      layout = Jason.decode!(json)["layout"]
      assert Map.has_key?(layout, "template")
      assert layout["template"] == template
      assert log == ""
    end
  end

  test "rendering preserves an inline custom template and explicit layout overrides" do
    template = %{layout: %{paper_bgcolor: "pink", font: %{color: "navy"}}}
    figure = Figure.new(layout: %{template: template, paper_bgcolor: "white"})
    layout = Jason.decode!(Figure.to_render_json(figure))["layout"]

    assert layout["template"] == Jason.decode!(Jason.encode!(template))
    assert layout["paper_bgcolor"] == "white"
  end

  @tag :requires_phoenix
  test "the LiveView component embeds concrete template defaults" do
    html =
      Phoenix.LiveViewTest.render_component(&Plotly.Phoenix.Component.plot/1,
        id: "named-template",
        figure: Figure.new(layout: %{template: "plotly_dark"})
      )

    [_, escaped] = Regex.run(~r/data-figure="([^"]*)"/, html)
    assert_dark_template(escaped |> String.replace("&quot;", "\"") |> Jason.decode!())
  end

  @tag :requires_phoenix
  test "an unknown template does not interrupt LiveView component rendering" do
    {html, log} =
      with_log(fn ->
        Phoenix.LiveViewTest.render_component(&Plotly.Phoenix.Component.plot/1,
          id: "unknown-template",
          figure: Figure.new(layout: %{template: :plotly_drak, width: 500})
        )
      end)

    assert log =~ "plotly_drak"
    assert log =~ "supported names:"
    [_, escaped] = Regex.run(~r/data-figure="([^"]*)"/, html)
    figure = escaped |> String.replace("&quot;", "\"") |> Jason.decode!()
    assert figure["layout"] == %{"template" => %{}, "width" => 500}
    assert figure["config"]["showSendToCloud"] == false
  end

  @tag :requires_phoenix
  test "the Phoenix static renderer embeds concrete template defaults" do
    {:safe, html} =
      Plotly.Phoenix.Component.static_plot(Figure.new(layout: %{template: "plotly_dark"}))

    [_, json] = Regex.run(~r/var fig=(.+?);(?:function|load)/, html)
    assert_dark_template(Jason.decode!(json))
  end

  @tag :requires_kino
  test "the static Kino payload contains concrete template defaults" do
    widget = Plotly.Kino.PlotlyStatic.new(Figure.new(layout: %{template: "plotly_dark"}))
    payload = :sys.get_state(Kino.JS.DataStore).ref_with_data[widget.ref].data |> Jason.decode!()

    assert_dark_template(Jason.decode!(payload["figureJson"]))
  end

  describe "live Kino templates" do
    @describetag :requires_kino
    import Kino.Test
    setup :configure_livebook_bridge

    test "initial, pushed and reconnected figures contain concrete template defaults" do
      figure = Figure.new(layout: %{template: "plotly_dark"})
      chart = Plotly.Kino.PlotlyLive.new(figure)
      payload = chart |> connect() |> Jason.decode!()
      assert_dark_template(Jason.decode!(payload["figureJson"]))

      Plotly.Kino.PlotlyLive.push(chart, Figure.update_layout(figure, title: "Updated"))
      assert_broadcast_event(chart, "update", json)
      assert_dark_template(Jason.decode!(json))
      assert Jason.decode!(json)["layout"]["title"] == "Updated"

      payload = chart |> connect() |> Jason.decode!()
      assert_dark_template(Jason.decode!(payload["figureJson"]))
    end
  end

  defp assert_dark_template(figure) do
    template = figure["layout"]["template"]
    assert is_map(template), "expected concrete template defaults, got: #{inspect(template)}"
    assert template["layout"]["paper_bgcolor"] == "rgb(17,17,17)"
    assert template["layout"]["font"]["color"] == "#f2f5fa"
  end
end

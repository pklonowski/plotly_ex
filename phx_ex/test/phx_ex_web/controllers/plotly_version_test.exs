defmodule PhxExWeb.PlotlyVersionTest do
  use PhxExWeb.ConnCase, async: true

  test "the demo delegates Plotly loading to the library hook", %{conn: conn} do
    document = conn |> get(~p"/") |> html_response(200) |> LazyHTML.from_document()

    preloaded_scripts = LazyHTML.query(document, "script[src*='plotly']")

    assert LazyHTML.attribute(preloaded_scripts, "src") == []

    chart = LazyHTML.query(document, "[phx-hook='PlotlyChart'][data-plotly-urls]")
    assert Enum.count(chart) == 1

    [urls] = LazyHTML.attribute(chart, "data-plotly-urls")
    assert List.last(Jason.decode!(urls)) == "/plotly_ex/plotly.min.js?v=4.1.2"
  end

  test "the demo serves the configured bundled Plotly fallback", %{conn: conn} do
    body = conn |> get(List.last(Plotly.PlotlyJS.source_urls())) |> response(200)

    assert binary_part(body, 0, min(byte_size(body), 120)) =~ "plotly.js v4.1.2"
  end
end

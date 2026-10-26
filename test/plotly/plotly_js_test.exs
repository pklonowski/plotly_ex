defmodule Plotly.PlotlyJSTest do
  use ExUnit.Case, async: true
  alias Plotly.PlotlyJS

  test "compatible_version is 4.1.2" do
    assert PlotlyJS.compatible_version() == "4.1.2"
  end

  test "version defaults to the compatible version" do
    assert PlotlyJS.version() == "4.1.2"
  end

  test "source defaults to :cdn" do
    assert PlotlyJS.source() == :cdn
  end

  test "cdn_url and jsdelivr_url embed the version" do
    assert PlotlyJS.cdn_url() == "https://cdn.plot.ly/plotly-4.1.2.min.js"

    assert PlotlyJS.jsdelivr_url() ==
             "https://cdn.jsdelivr.net/npm/plotly.js@4.1.2/dist/plotly.min.js"
  end

  test "bundled_path defaults to the namespaced public URL" do
    assert PlotlyJS.bundled_path() == "/plotly_ex/plotly.min.js"
  end

  test "source_urls for :cdn is cdn then jsdelivr then bundled" do
    assert PlotlyJS.source_urls() == [
             "https://cdn.plot.ly/plotly-4.1.2.min.js",
             "https://cdn.jsdelivr.net/npm/plotly.js@4.1.2/dist/plotly.min.js",
             "/plotly_ex/plotly.min.js?v=4.1.2"
           ]
  end

  test "bundled_priv_path points at an existing 4.1.2 file" do
    path = PlotlyJS.bundled_priv_path()
    assert File.exists?(path)
    assert File.read!(path) |> String.contains?("plotly.js v4.1.2")
  end

  test "kino_source_urls ends in the relative asset path" do
    assert List.last(PlotlyJS.kino_source_urls()) == "./plotly.min.js"
  end

  test "warning_message names the engaged source and the version" do
    msg = PlotlyJS.warning_message("/plotly_ex/plotly.min.js")
    assert msg =~ "4.1.2"
    assert msg =~ "/plotly_ex/plotly.min.js"
    assert msg =~ "fell back"
  end
end

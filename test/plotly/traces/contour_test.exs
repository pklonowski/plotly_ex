defmodule Plotly.Traces.ContourTest do
  use ExUnit.Case, async: true
  alias Plotly.Contour

  test "basic z matrix passes through" do
    c = Contour.new(z: [[1, 2], [3, 4]])
    assert c.z == [[1, 2], [3, 4]]
    assert c.type == "contour"
  end

  test "contours map with start/end/size/showlabels passes through" do
    c =
      Contour.new(
        z: [[1, 2], [3, 4]],
        contours: %{start: 1, end: 4, size: 1, showlabels: true}
      )

    assert c.contours.start == 1
    assert c.contours.showlabels == true
  end

  test "colorbar, colorscale, connectgaps, line pass through" do
    c =
      Contour.new(
        z: [[1, 2], [3, 4]],
        colorscale: "Viridis",
        connectgaps: true,
        line: %{smoothing: 1.3},
        colorbar: %{title: %{text: "Values"}}
      )

    assert c.colorscale == "Viridis"
    assert c.connectgaps == true
    assert c.line.smoothing == 1.3
    assert c.colorbar.title.text == "Values"
  end
end

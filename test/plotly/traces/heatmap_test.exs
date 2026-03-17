defmodule Plotly.Traces.HeatmapTest do
  use ExUnit.Case, async: true
  alias Plotly.Heatmap

  test "basic z matrix passes through" do
    h = Heatmap.new(z: [[1, 2], [3, 4]])
    assert h.z == [[1, 2], [3, 4]]
    assert h.type == "heatmap"
  end

  test "string x and y axes pass through" do
    h = Heatmap.new(z: [[1, 2], [3, 4]], x: ["A", "B"], y: ["X", "Y"])
    assert h.x == ["A", "B"]
    assert h.y == ["X", "Y"]
  end

  test "texttemplate and colorscale pass through" do
    h =
      Heatmap.new(
        z: [[1, 2], [3, 4]],
        texttemplate: "%{z}",
        colorscale: "Blues"
      )

    assert h.texttemplate == "%{z}"
    assert h.colorscale == "Blues"
  end
end

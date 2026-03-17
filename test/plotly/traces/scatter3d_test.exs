defmodule Plotly.Traces.Scatter3dTest do
  use ExUnit.Case, async: true
  alias Plotly.Scatter3d

  test "basic x/y/z fields pass through" do
    t = Scatter3d.new(x: [1, 2, 3], y: [4, 5, 6], z: [7, 8, 9])
    assert t.x == [1, 2, 3]
    assert t.z == [7, 8, 9]
    assert t.type == "scatter3d"
  end

  test "surfaceaxis passes through for ribbon plots" do
    t = Scatter3d.new(x: [0, 1], y: [0, 0], z: [1, 2], mode: "lines", surfaceaxis: 1)
    assert t.surfaceaxis == 1
    assert t.mode == "lines"
  end
end

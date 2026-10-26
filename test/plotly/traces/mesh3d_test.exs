defmodule Plotly.Traces.Mesh3dTest do
  use ExUnit.Case, async: true
  alias Plotly.Mesh3d

  test "basic x/y/z with alphahull passes through" do
    t = Mesh3d.new(x: [0, 1, 2, 0], y: [0, 0, 1, 1], z: [0, 1, 0, 1], alphahull: 5)
    assert t.alphahull == 5
    assert t.type == "mesh3d"
  end

  test "explicit face connectivity i/j/k passes through" do
    t =
      Mesh3d.new(
        x: [0, 1, 2, 0],
        y: [0, 0, 1, 2],
        z: [0, 2, 0, 1],
        i: [0, 0, 0, 1],
        j: [1, 2, 3, 2],
        k: [2, 3, 1, 3]
      )

    assert t.i == [0, 0, 0, 1]
    assert t.k == [2, 3, 1, 3]
  end
end

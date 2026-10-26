defmodule Plotly.Traces.ConeTest do
  use ExUnit.Case, async: true
  alias Plotly.Cone

  test "basic position + vector fields pass through" do
    t = Cone.new(x: [1, 2], y: [1, 2], z: [1, 2], u: [1, 0], v: [0, 1], w: [0, 0])
    assert t.x == [1, 2]
    assert t.u == [1, 0]
    assert t.type == "cone"
  end

  test "sizemode and sizeref pass through" do
    t =
      Cone.new(
        x: [0],
        y: [0],
        z: [0],
        u: [1],
        v: [0],
        w: [0],
        sizemode: "absolute",
        sizeref: 2
      )

    assert t.sizemode == "absolute"
    assert t.sizeref == 2
  end
end

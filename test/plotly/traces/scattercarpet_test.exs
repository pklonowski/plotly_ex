defmodule Plotly.Traces.ScattercarpetTest do
  use ExUnit.Case, async: true
  alias Plotly.Scattercarpet

  test "basic a/b/carpet pass through" do
    t = Scattercarpet.new(a: [1, 2], b: [1, 2], carpet: "c1")
    assert t.a == [1, 2]
    assert t.b == [1, 2]
    assert t.carpet == "c1"
    assert t.type == "scattercarpet"
  end

  test "line smoothing and marker pass through" do
    t =
      Scattercarpet.new(
        a: [1],
        b: [1],
        carpet: "c1",
        line: %{shape: "spline", smoothing: 1},
        marker: %{size: 10, color: "red"}
      )

    assert t.line == %{shape: "spline", smoothing: 1}
    assert t.marker == %{size: 10, color: "red"}
  end
end

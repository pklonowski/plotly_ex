defmodule Plotly.Traces.ScatterternaryTest do
  use ExUnit.Case, async: true
  alias Plotly.Scatterternary

  test "basic a/b/c coordinates pass through" do
    t = Scatterternary.new(a: [1, 2], b: [3, 4], c: [5, 6], mode: "markers")
    assert t.a == [1, 2]
    assert t.b == [3, 4]
    assert t.c == [5, 6]
    assert t.mode == "markers"
    assert t.type == "scatterternary"
  end

  test "fill and fillcolor pass through" do
    t = Scatterternary.new(a: [1], b: [1], c: [1], fill: "toself", fillcolor: "red")
    assert t.fill == "toself"
    assert t.fillcolor == "red"
  end
end

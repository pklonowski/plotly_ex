defmodule Plotly.Traces.ScatterpolarTest do
  use ExUnit.Case, async: true
  alias Plotly.Scatterpolar

  test "basic r and theta pass through" do
    s = Scatterpolar.new(r: [1, 2, 3], theta: [0, 90, 180])
    assert s.r == [1, 2, 3]
    assert s.theta == [0, 90, 180]
    assert s.type == "scatterpolar"
  end

  test "fill toself and mode lines pass through" do
    s = Scatterpolar.new(r: [1, 2], theta: [0, 90], fill: "toself", mode: "lines")
    assert s.fill == "toself"
    assert s.mode == "lines"
  end

  test "subplot reference passes through" do
    s = Scatterpolar.new(r: [1], theta: [0], subplot: "polar2")
    assert s.subplot == "polar2"
  end
end

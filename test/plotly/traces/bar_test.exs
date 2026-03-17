defmodule Plotly.Traces.BarTest do
  use ExUnit.Case, async: true
  alias Plotly.Bar

  test "width as list passes through" do
    b = Bar.new(x: ["A", "B", "C"], y: [1, 2, 3], width: [0.5, 0.8, 0.3])
    assert b.width == [0.5, 0.8, 0.3]
  end
end

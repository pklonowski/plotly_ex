defmodule Plotly.Traces.ViolinTest do
  use ExUnit.Case, async: true
  alias Plotly.Violin

  test "basic y-data passes through" do
    v = Violin.new(y: [1, 2, 3, 4, 5])
    assert v.y == [1, 2, 3, 4, 5]
    assert v.type == "violin"
  end

  test "side and box pass through" do
    v = Violin.new(y: [1, 2, 3], side: "positive", box: %{visible: true})
    assert v.side == "positive"
    assert v.box.visible == true
  end

  test "points, meanline, orientation pass through" do
    v = Violin.new(y: [1, 2, 3], points: "all", meanline: %{visible: true}, orientation: "h")
    assert v.points == "all"
    assert v.meanline.visible == true
    assert v.orientation == "h"
  end
end

defmodule Plotly.Traces.BoxTest do
  use ExUnit.Case, async: true
  alias Plotly.Box

  test "basic y-data passes through" do
    b = Box.new(y: [1, 2, 3, 4, 5])
    assert b.y == [1, 2, 3, 4, 5]
    assert b.type == "box"
  end

  test "boxpoints, jitter, boxmean pass through" do
    b =
      Box.new(
        y: [1, 2, 3, 4, 5],
        boxpoints: "all",
        jitter: 0.3,
        boxmean: "sd"
      )

    assert b.boxpoints == "all"
    assert b.jitter == 0.3
    assert b.boxmean == "sd"
  end

  test "orientation h with x-data passes through" do
    b = Box.new(x: [1, 2, 3], orientation: "h")
    assert b.x == [1, 2, 3]
    assert b.orientation == "h"
  end
end

defmodule Plotly.SubplotsTest do
  use ExUnit.Case, async: true
  alias Plotly.{Figure, Scatter}

  test "layout.grid passthrough" do
    fig =
      Figure.new()
      |> Figure.update_layout(grid: %{rows: 2, columns: 1, pattern: "independent"})

    assert fig.layout.grid.rows == 2
    assert fig.layout.grid.pattern == "independent"
  end

  test "Scatter xaxis/yaxis axis reference passthrough" do
    t = Scatter.new(x: [1, 2], y: [3, 4], xaxis: "x2", yaxis: "y2")
    assert t.xaxis == "x2"
    assert t.yaxis == "y2"
  end

  test "dual y-axis layout passthrough" do
    fig =
      Figure.new()
      |> Figure.update_layout(
        yaxis2: %{overlaying: "y", side: "right", title: %{text: "Right Y"}}
      )

    assert fig.layout.yaxis2.overlaying == "y"
    assert fig.layout.yaxis2.side == "right"
  end
end

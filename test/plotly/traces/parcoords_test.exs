defmodule Plotly.Traces.ParcoordsTest do
  use ExUnit.Case, async: true
  alias Plotly.Parcoords

  test "basic dimensions pass through" do
    p = Parcoords.new(dimensions: [%{label: "x", values: [1, 2, 3]}])
    assert length(p.dimensions) == 1
    assert hd(p.dimensions).label == "x"
    assert p.type == "parcoords"
  end

  test "line with color and colorscale passes through" do
    p =
      Parcoords.new(
        dimensions: [%{label: "x", values: [1, 2]}],
        line: %{color: [1, 2], colorscale: "Viridis"}
      )

    assert p.line.colorscale == "Viridis"
    assert p.line.color == [1, 2]
  end

  test "dimension with constraintrange and tickvals passes through" do
    p =
      Parcoords.new(
        dimensions: [
          %{
            label: "x",
            values: [1, 2, 3],
            range: [0, 4],
            constraintrange: [1, 2],
            tickvals: [1, 2, 3],
            ticktext: ["low", "mid", "high"]
          }
        ]
      )

    dim = hd(p.dimensions)
    assert dim.constraintrange == [1, 2]
    assert dim.ticktext == ["low", "mid", "high"]
  end
end

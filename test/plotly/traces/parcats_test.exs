defmodule Plotly.Traces.ParcatsTest do
  use ExUnit.Case, async: true
  alias Plotly.Parcats

  test "basic dimensions pass through" do
    p = Parcats.new(dimensions: [%{values: ["A", "B", "A"], label: "Cat"}])
    assert length(p.dimensions) == 1
    assert hd(p.dimensions).label == "Cat"
    assert p.type == "parcats"
  end

  test "counts and line pass through" do
    p =
      Parcats.new(
        dimensions: [%{values: ["A", "B"], label: "X"}],
        counts: [10, 20],
        line: %{color: [0, 1], colorscale: "Jet"}
      )

    assert p.counts == [10, 20]
    assert p.line.colorscale == "Jet"
  end
end

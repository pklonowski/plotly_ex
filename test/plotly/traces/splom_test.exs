defmodule Plotly.Traces.SplomTest do
  use ExUnit.Case, async: true
  alias Plotly.Splom

  test "basic dimensions pass through" do
    s = Splom.new(dimensions: [%{label: "x", values: [1, 2, 3]}])
    assert length(s.dimensions) == 1
    assert hd(s.dimensions).label == "x"
    assert s.type == "splom"
  end

  test "marker color and diagonal pass through" do
    s =
      Splom.new(
        dimensions: [%{label: "a", values: [1, 2]}],
        marker: %{color: [0, 1], colorscale: "Viridis"},
        diagonal: %{visible: false}
      )

    assert s.marker.colorscale == "Viridis"
    assert s.diagonal.visible == false
  end
end

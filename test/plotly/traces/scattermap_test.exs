defmodule Plotly.Traces.ScattermapTest do
  use ExUnit.Case, async: true
  alias Plotly.Scattermap

  test "lat/lon/mode pass through" do
    t = Scattermap.new(lat: [40.7], lon: [-74.0], mode: "markers")
    assert t.lat == [40.7]
    assert t.lon == [-74.0]
    assert t.mode == "markers"
    assert t.type == "scattermap"
  end

  test "fill and fillcolor pass through" do
    t =
      Scattermap.new(
        lat: [40.7],
        lon: [-74.0],
        mode: "lines",
        fill: "toself",
        fillcolor: "rgba(0,0,255,0.3)"
      )

    assert t.fill == "toself"
    assert t.fillcolor == "rgba(0,0,255,0.3)"
  end
end

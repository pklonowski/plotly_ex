defmodule Plotly.Traces.ScattergeoTest do
  use ExUnit.Case, async: true
  alias Plotly.Scattergeo

  test "lat/lon/mode pass through" do
    t = Scattergeo.new(lat: [51.5], lon: [-0.1], mode: "lines")
    assert t.lat == [51.5]
    assert t.lon == [-0.1]
    assert t.mode == "lines"
    assert t.type == "scattergeo"
  end

  test "locations and locationmode pass through" do
    t = Scattergeo.new(locations: ["NY"], locationmode: "USA-states")
    assert t.locations == ["NY"]
    assert t.locationmode == "USA-states"
  end

  test "marker map passes through" do
    t =
      Scattergeo.new(
        lat: [40.7],
        lon: [-74.0],
        marker: %{size: 10, color: "red", colorscale: "Viridis"}
      )

    assert t.marker.size == 10
    assert t.marker.color == "red"
  end
end

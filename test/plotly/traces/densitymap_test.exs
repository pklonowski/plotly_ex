defmodule Plotly.Traces.DensitymapTest do
  use ExUnit.Case, async: true
  alias Plotly.Densitymap

  test "lat/lon/radius pass through" do
    t = Densitymap.new(lat: [40.7], lon: [-74.0], radius: 10)
    assert t.lat == [40.7]
    assert t.lon == [-74.0]
    assert t.radius == 10
    assert t.type == "densitymap"
  end

  test "z and colorscale pass through" do
    t = Densitymap.new(lat: [40.7], lon: [-74.0], z: [5.0], colorscale: "Hot")
    assert t.z == [5.0]
    assert t.colorscale == "Hot"
  end
end

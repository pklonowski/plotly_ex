defmodule Plotly.Traces.ChoroplethMapTest do
  use ExUnit.Case, async: true
  alias Plotly.Choroplethmap

  test "geojson/locations/z/featureidkey pass through" do
    t = Choroplethmap.new(geojson: %{}, locations: ["1"], z: [1.0], featureidkey: "id")
    assert t.geojson == %{}
    assert t.locations == ["1"]
    assert t.z == [1.0]
    assert t.featureidkey == "id"
    assert t.type == "choroplethmap"
  end
end

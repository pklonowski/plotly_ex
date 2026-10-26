defmodule Plotly.Traces.ChoroplethTest do
  use ExUnit.Case, async: true
  alias Plotly.Choropleth

  test "locations/z/locationmode pass through" do
    t = Choropleth.new(locations: ["USA"], z: [1.0], locationmode: "ISO-3")
    assert t.locations == ["USA"]
    assert t.z == [1.0]
    assert t.locationmode == "ISO-3"
    assert t.type == "choropleth"
  end

  test "colorscale and reversescale pass through" do
    t = Choropleth.new(locations: ["USA"], z: [1.0], colorscale: "Viridis", reversescale: true)
    assert t.colorscale == "Viridis"
    assert t.reversescale == true
  end
end

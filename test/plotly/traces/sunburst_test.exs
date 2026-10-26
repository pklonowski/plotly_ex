defmodule Plotly.Traces.SunburstTest do
  use ExUnit.Case, async: true
  alias Plotly.Sunburst

  test "basic fields pass through" do
    s =
      Sunburst.new(
        labels: ["Root", "Child"],
        parents: ["", "Root"],
        values: [10, 5]
      )

    assert s.labels == ["Root", "Child"]
    assert s.parents == ["", "Root"]
    assert s.values == [10, 5]
    assert s.type == "sunburst"
  end

  test "ids, branchvalues, maxdepth, insidetextorientation pass through" do
    s =
      Sunburst.new(
        labels: ["Root", "Child"],
        parents: ["", "Root"],
        ids: ["root-id", "child-id"],
        branchvalues: "total",
        maxdepth: 2,
        insidetextorientation: "radial"
      )

    assert s.ids == ["root-id", "child-id"]
    assert s.branchvalues == "total"
    assert s.maxdepth == 2
    assert s.insidetextorientation == "radial"
  end
end

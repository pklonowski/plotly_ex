defmodule Plotly.Traces.TreemapTest do
  use ExUnit.Case, async: true
  alias Plotly.Treemap

  test "labels, parents, values pass through" do
    t =
      Treemap.new(
        labels: ["Root", "A", "B"],
        parents: ["", "Root", "Root"],
        values: [0, 10, 20],
        branchvalues: "remainder"
      )

    assert t.labels == ["Root", "A", "B"]
    assert t.branchvalues == "remainder"
    assert t.type == "treemap"
  end

  test "tiling and marker pass through" do
    t =
      Treemap.new(
        labels: ["Root", "A"],
        parents: ["", "Root"],
        tiling: %{packing: "squarify"},
        marker: %{colors: ["blue", "red"]}
      )

    assert t.tiling.packing == "squarify"
    assert t.marker.colors == ["blue", "red"]
  end
end

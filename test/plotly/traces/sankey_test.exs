defmodule Plotly.Traces.SankeyTest do
  use ExUnit.Case, async: true
  alias Plotly.Sankey

  test "node and link pass through" do
    s =
      Sankey.new(
        node: %{label: ["A", "B", "C"], color: ["blue", "red", "green"]},
        link: %{source: [0, 1], target: [2, 2], value: [4, 2]}
      )

    assert s.node.label == ["A", "B", "C"]
    assert s.link.source == [0, 1]
    assert s.link.value == [4, 2]
    assert s.type == "sankey"
  end

  test "arrangement and domain pass through" do
    s =
      Sankey.new(
        node: %{label: ["A", "B"], x: [0.1, 0.9], y: [0.5, 0.5]},
        link: %{source: [0], target: [1], value: [1]},
        arrangement: "fixed"
      )

    assert s.arrangement == "fixed"
    assert s.node.x == [0.1, 0.9]
  end
end

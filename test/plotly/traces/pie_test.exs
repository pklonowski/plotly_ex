defmodule Plotly.PieTest do
  use ExUnit.Case, async: true
  alias Plotly.Pie

  test "hole and domain pass through" do
    p =
      Pie.new(
        labels: ["A", "B"],
        values: [60, 40],
        hole: 0.4,
        domain: %{x: [0, 0.5], y: [0, 1]}
      )

    assert p.hole == 0.4
    assert p.domain == %{x: [0, 0.5], y: [0, 1]}
  end

  test "texttemplate is accepted" do
    p =
      Pie.new(
        labels: ["A", "B", "C"],
        values: [10, 20, 30],
        texttemplate: "%{label}: %{value} (%{percent})",
        textposition: "inside"
      )

    assert p.texttemplate == "%{label}: %{value} (%{percent})"
  end
end

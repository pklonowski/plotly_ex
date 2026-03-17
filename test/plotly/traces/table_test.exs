defmodule Plotly.Traces.TableTest do
  use ExUnit.Case, async: true
  alias Plotly.Table

  test "header and cells pass through" do
    t =
      Table.new(
        header: %{values: ["Name", "Age"]},
        cells: %{values: [["Alice", "Bob"], [25, 30]]}
      )

    assert t.header.values == ["Name", "Age"]
    assert t.cells.values == [["Alice", "Bob"], [25, 30]]
    assert t.type == "table"
  end

  test "columnwidth and domain pass through" do
    t =
      Table.new(
        header: %{values: ["A"]},
        cells: %{values: [[1, 2]]},
        columnwidth: [200],
        domain: %{x: [0, 0.5], y: [0, 1]}
      )

    assert t.columnwidth == [200]
    assert t.domain.x == [0, 0.5]
  end
end

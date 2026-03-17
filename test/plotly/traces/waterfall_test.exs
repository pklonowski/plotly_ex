defmodule Plotly.Traces.WaterfallTest do
  use ExUnit.Case, async: true
  alias Plotly.Waterfall

  test "basic x/y/measure pass through" do
    t =
      Waterfall.new(
        x: ["Sales", "Consulting", "Profit"],
        y: [60, 80, 0],
        measure: ["relative", "relative", "total"]
      )

    assert t.x == ["Sales", "Consulting", "Profit"]
    assert t.y == [60, 80, 0]
    assert t.measure == ["relative", "relative", "total"]
    assert t.type == "waterfall"
  end

  test "styling fields pass through" do
    t =
      Waterfall.new(
        x: ["A"],
        y: [10],
        measure: ["absolute"],
        decreasing: %{marker: %{color: "Maroon"}},
        increasing: %{marker: %{color: "Teal"}},
        totals: %{marker: %{color: "deep sky blue"}},
        connector: %{mode: "between", line: %{width: 4, color: "black"}}
      )

    assert t.decreasing == %{marker: %{color: "Maroon"}}
    assert t.connector == %{mode: "between", line: %{width: 4, color: "black"}}
  end
end

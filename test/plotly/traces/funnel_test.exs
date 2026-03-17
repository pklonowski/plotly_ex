defmodule Plotly.Traces.FunnelTest do
  use ExUnit.Case, async: true
  alias Plotly.{Funnel, Funnelarea}

  test "basic funnel x/y pass through" do
    t =
      Funnel.new(
        x: [13873, 10533, 5443, 2703, 908],
        y: ["Website visit", "Downloads", "Potential customers", "Invoice sent", "Closed deals"]
      )

    assert t.x == [13873, 10533, 5443, 2703, 908]
    assert t.type == "funnel"
  end

  test "funnel marker and connector pass through" do
    t =
      Funnel.new(
        x: [100],
        y: ["Step A"],
        marker: %{color: ["red"], line: %{width: [2], color: ["blue"]}},
        connector: %{line: %{color: "royalblue", dash: "dot", width: 3}},
        textinfo: "value+percent initial"
      )

    assert t.connector == %{line: %{color: "royalblue", dash: "dot", width: 3}}
    assert t.textinfo == "value+percent initial"
  end

  test "funnelarea values/text pass through" do
    t =
      Funnelarea.new(
        values: [5, 4, 3, 2, 1],
        text: ["The 1st", "The 2nd", "The 3rd", "The 4th", "The 5th"],
        scalegroup: "first"
      )

    assert t.values == [5, 4, 3, 2, 1]
    assert t.scalegroup == "first"
    assert t.type == "funnelarea"
  end
end

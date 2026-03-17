defmodule Plotly.Traces.IndicatorTest do
  use ExUnit.Case, async: true
  alias Plotly.Indicator

  test "gauge+number mode passes through" do
    t =
      Indicator.new(
        mode: "gauge+number",
        value: 450,
        title: %{text: "Speed"},
        delta: %{reference: 400},
        gauge: %{axis: %{range: [nil, 500]}}
      )

    assert t.mode == "gauge+number"
    assert t.value == 450
    assert t.gauge == %{axis: %{range: [nil, 500]}}
    assert t.type == "indicator"
  end

  test "number+delta mode with formatting passes through" do
    t =
      Indicator.new(
        mode: "number+delta",
        value: 400,
        number: %{prefix: "$"},
        delta: %{position: "top", reference: 320}
      )

    assert t.number == %{prefix: "$"}
    assert t.delta == %{position: "top", reference: 320}
  end

  test "domain and bullet gauge pass through" do
    t =
      Indicator.new(
        mode: "number+gauge+delta",
        value: 220,
        gauge: %{shape: "bullet"},
        domain: %{x: [0, 1], y: [0, 1]}
      )

    assert t.gauge == %{shape: "bullet"}
    assert t.domain == %{x: [0, 1], y: [0, 1]}
  end
end

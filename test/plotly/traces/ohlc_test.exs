defmodule Plotly.Traces.OhlcTest do
  use ExUnit.Case, async: true
  alias Plotly.Ohlc

  test "basic OHLC fields pass through" do
    t =
      Ohlc.new(
        x: ["2017-01-04", "2017-01-05"],
        open: [115.85, 115.92],
        high: [116.51, 116.86],
        low: [115.75, 115.81],
        close: [116.02, 116.61]
      )

    assert t.x == ["2017-01-04", "2017-01-05"]
    assert t.open == [115.85, 115.92]
    assert t.type == "ohlc"
  end

  test "increasing/decreasing styling passes through" do
    t =
      Ohlc.new(
        x: ["2020-01-01"],
        open: [100.0],
        high: [110.0],
        low: [90.0],
        close: [105.0],
        increasing: %{line: %{color: "green"}},
        decreasing: %{line: %{color: "red"}}
      )

    assert t.increasing == %{line: %{color: "green"}}
    assert t.decreasing == %{line: %{color: "red"}}
  end
end

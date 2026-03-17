defmodule Plotly.Traces.CandlestickTest do
  use ExUnit.Case, async: true
  alias Plotly.Candlestick

  test "basic OHLC fields pass through" do
    t =
      Candlestick.new(
        x: ["2017-01-04", "2017-01-05"],
        open: [115.85, 115.92],
        high: [116.51, 116.86],
        low: [115.75, 115.81],
        close: [116.02, 116.61]
      )

    assert t.x == ["2017-01-04", "2017-01-05"]
    assert t.open == [115.85, 115.92]
    assert t.type == "candlestick"
  end

  test "increasing/decreasing styling passes through" do
    t =
      Candlestick.new(
        x: ["2017-01-04"],
        open: [115.0],
        high: [116.0],
        low: [114.0],
        close: [115.5],
        increasing: %{line: %{color: "black"}},
        decreasing: %{line: %{color: "red"}}
      )

    assert t.increasing == %{line: %{color: "black"}}
    assert t.decreasing == %{line: %{color: "red"}}
  end
end

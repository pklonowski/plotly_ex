defmodule Plotly.Traces.HistogramTest do
  use ExUnit.Case, async: true
  alias Plotly.Histogram

  test "basic x-data passes through" do
    h = Histogram.new(x: [1, 2, 2, 3, 3, 3])
    assert h.x == [1, 2, 2, 3, 3, 3]
    assert h.type == "histogram"
  end

  test "histnorm and cumulative pass through" do
    h =
      Histogram.new(
        x: [1, 2, 3],
        histnorm: "probability",
        cumulative: %{enabled: true}
      )

    assert h.histnorm == "probability"
    assert h.cumulative.enabled == true
  end

  test "histfunc and nbinsx pass through" do
    h = Histogram.new(x: [1, 2, 3], histfunc: "count", nbinsx: 20)
    assert h.histfunc == "count"
    assert h.nbinsx == 20
  end
end

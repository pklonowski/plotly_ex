defmodule Plotly.ScatterglTest do
  use ExUnit.Case, async: true
  alias Plotly.Scattergl

  test "mode text is accepted" do
    s =
      Scattergl.new(
        x: [1, 2, 3],
        y: [1, 2, 3],
        mode: "text",
        text: ["A", "B", "C"]
      )

    assert s.mode == "text"
    assert s.text == ["A", "B", "C"]
  end
end

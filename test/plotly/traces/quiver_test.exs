defmodule Plotly.QuiverTest do
  use ExUnit.Case, async: true

  test "constructs and serializes vector field components without nil fields" do
    trace = Plotly.Quiver.new(x: [0, 1], y: [2, 3], u: [4, 5], v: [6, 7])
    assert trace.type == "quiver"

    assert Jason.decode!(Jason.encode!(trace)) == %{
             "type" => "quiver",
             "x" => [0, 1],
             "y" => [2, 3],
             "u" => [4, 5],
             "v" => [6, 7]
           }
  end

  test "accepts vector scaling options and rejects unsupported keys in keyword and map opts" do
    for opts <- [
          [anchor: "tail", lengthmode: "scaled", lengthfactor: 0.5],
          %{anchor: "tail", lengthmode: "scaled", lengthfactor: 0.5}
        ] do
      trace = Plotly.Quiver.new(opts)
      assert trace.anchor == "tail"
      assert trace.lengthmode == "scaled"
      assert trace.lengthfactor == 0.5
    end

    for key <- [:sizemode, :stream, :xsrc], opts <- [[{key, true}], %{key => true}] do
      assert_raise ArgumentError, ~r/unknown keys \[#{inspect(key)}\]/, fn ->
        Plotly.Quiver.new(opts)
      end
    end
  end
end

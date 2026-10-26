defmodule Plotly.Traces.StreamtubeTest do
  use ExUnit.Case, async: true
  alias Plotly.Streamtube

  test "basic vector field fields pass through" do
    t = Streamtube.new(x: [0, 1], y: [0, 1], z: [0, 1], u: [1, 0], v: [0, 1], w: [0, 0])
    assert t.x == [0, 1]
    assert t.type == "streamtube"
  end

  test "starts and maxdisplayed pass through" do
    t =
      Streamtube.new(
        x: [0],
        y: [0],
        z: [0],
        u: [1],
        v: [0],
        w: [0],
        starts: %{x: [0], y: [0], z: [0]},
        maxdisplayed: 10
      )

    assert t.starts == %{x: [0], y: [0], z: [0]}
    assert t.maxdisplayed == 10
  end
end

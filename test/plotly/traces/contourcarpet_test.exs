defmodule Plotly.Traces.ContourcarpetTest do
  use ExUnit.Case, async: true
  alias Plotly.Contourcarpet

  test "basic a/b/z/carpet pass through" do
    t = Contourcarpet.new(a: [0, 1], b: [4, 4], z: [1, 2], carpet: "c1")
    assert t.a == [0, 1]
    assert t.b == [4, 4]
    assert t.z == [1, 2]
    assert t.carpet == "c1"
    assert t.type == "contourcarpet"
  end

  test "contours and colorscale pass through" do
    t =
      Contourcarpet.new(
        a: [0],
        b: [4],
        z: [1],
        carpet: "c1",
        autocontour: false,
        contours: %{start: 1, end: 14, size: 1},
        colorscale: "Viridis"
      )

    assert t.autocontour == false
    assert t.contours == %{start: 1, end: 14, size: 1}
    assert t.colorscale == "Viridis"
  end
end

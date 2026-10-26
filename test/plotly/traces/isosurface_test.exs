defmodule Plotly.Traces.IsosurfaceTest do
  use ExUnit.Case, async: true
  alias Plotly.Isosurface

  test "basic scalar field fields pass through" do
    t = Isosurface.new(x: [0, 1], y: [0, 1], z: [0, 1], value: [0.5, 1.5], isomin: 0, isomax: 2)
    assert t.value == [0.5, 1.5]
    assert t.isomin == 0
    assert t.type == "isosurface"
  end

  test "slices and caps pass through" do
    t =
      Isosurface.new(
        x: [0],
        y: [0],
        z: [0],
        value: [1],
        isomin: 0,
        isomax: 2,
        slices: %{x: %{show: true, locations: [0]}},
        caps: %{x: %{show: false}, y: %{show: false}, z: %{show: true}},
        surface: %{count: 3}
      )

    assert t.slices == %{x: %{show: true, locations: [0]}}
    assert t.surface == %{count: 3}
  end
end

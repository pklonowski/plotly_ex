defmodule Plotly.RawJSTest do
  use ExUnit.Case, async: true
  doctest Plotly.RawJS

  alias Plotly.RawJS

  describe "new/1" do
    test "creates a RawJS struct with given value" do
      r = RawJS.new("function(gd) { alert('hi'); }")
      assert %RawJS{value: "function(gd) { alert('hi'); }"} = r
    end
  end

  describe "Jason.Encoder" do
    test "encodes as __rawjs__ marker object for browser-side eval" do
      r = RawJS.new("Plotly.Icons.camera")
      decoded = r |> Jason.encode!() |> Jason.decode!()
      assert decoded == %{"__rawjs__" => "Plotly.Icons.camera"}
    end

    test "encodes function strings as __rawjs__ marker" do
      r = RawJS.new("function(gd) { alert('hi'); }")
      decoded = r |> Jason.encode!() |> Jason.decode!()
      assert decoded == %{"__rawjs__" => "function(gd) { alert('hi'); }"}
    end

    test "encodes correctly when nested in a map" do
      map = %{click: RawJS.new("function(gd) {}"), name: "test"}
      decoded = map |> Jason.encode!() |> Jason.decode!()
      assert decoded["click"] == %{"__rawjs__" => "function(gd) {}"}
      assert decoded["name"] == "test"
    end

    test "roundtrips through Figure config as __rawjs__ markers" do
      alias Plotly.Figure

      fig =
        Figure.new(
          config: %{
            modeBarButtonsToAdd: [
              %{
                name: "custom",
                click: RawJS.new("function(gd) { console.log(gd); }")
              }
            ]
          }
        )

      decoded = fig |> Figure.to_json() |> Jason.decode!()
      btn = decoded["config"]["modeBarButtonsToAdd"] |> List.first()
      assert btn["click"] == %{"__rawjs__" => "function(gd) { console.log(gd); }"}
    end

    test "keyword list modeBarButtonsToAdd with RawJS encodes icon and click as markers" do
      alias Plotly.{Figure, Scatter}

      fig =
        Figure.new(
          data: [Scatter.new(x: [1, 2, 3, 4, 5], y: [2, 4, 1, 5, 3], mode: "lines+markers")],
          layout: %{title: "Chart with custom modebar button structure"},
          config: %{
            displayModeBar: true,
            modeBarButtonsToAdd: [
              [
                name: "alert_button",
                title: "Click me",
                icon: RawJS.new("Plotly.Icons.camera"),
                click: RawJS.new("function(gd) { alert('Chart id: ' + gd.id); }")
              ]
            ]
          }
        )

      decoded = fig |> Figure.to_json() |> Jason.decode!()
      btn = decoded["config"]["modeBarButtonsToAdd"] |> List.first()
      assert btn["name"] == "alert_button"
      assert btn["icon"] == %{"__rawjs__" => "Plotly.Icons.camera"}
      assert btn["click"] == %{"__rawjs__" => "function(gd) { alert('Chart id: ' + gd.id); }"}
    end
  end
end

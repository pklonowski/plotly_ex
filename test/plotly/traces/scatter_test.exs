defmodule Plotly.ScatterTest do
  use ExUnit.Case, async: true

  alias Plotly.Scatter

  describe "new/1" do
    test "builds a struct with defaults" do
      s = Scatter.new()
      assert s.type == "scatter"
      assert is_nil(s.x)
      assert is_nil(s.y)
    end

    test "accepts known keys" do
      s = Scatter.new(x: [1, 2, 3], y: [4, 5, 6], mode: "lines", name: "series1")
      assert s.x == [1, 2, 3]
      assert s.y == [4, 5, 6]
      assert s.mode == "lines"
      assert s.name == "series1"
    end

    test "raises ArgumentError on unknown key (not KeyError)" do
      assert_raise ArgumentError, ~r/unknown keys/, fn ->
        Scatter.new(colur: "red")
      end
    end

    test "marker color as numeric array passes through" do
      s =
        Scatter.new(
          x: [1, 2, 3],
          y: [4, 5, 6],
          marker: %{color: [10, 20, 30], colorscale: "Viridis", showscale: true}
        )

      assert s.marker.color == [10, 20, 30]
      assert s.marker.colorscale == "Viridis"
    end

    test "line shape spline is accepted" do
      s = Scatter.new(x: [1, 2, 3], y: [1, 2, 1], line: %{shape: "spline"})
      assert s.line.shape == "spline"
    end

    test "marker sizemode and sizeref pass through (bubble scaling)" do
      s =
        Scatter.new(
          x: [1, 2, 3],
          y: [1, 2, 3],
          mode: "markers",
          marker: %{size: [10, 20, 30], sizemode: "area", sizeref: 0.01}
        )

      assert s.marker.sizemode == "area"
      assert s.marker.sizeref == 0.01
    end

    test "stackgroup and groupnorm pass through (normalized stacked area)" do
      s =
        Scatter.new(
          x: [1, 2, 3],
          y: [10, 20, 30],
          fill: "tonexty",
          stackgroup: "one",
          groupnorm: "percent"
        )

      assert s.stackgroup == "one"
      assert s.groupnorm == "percent"
    end

    test "error_y with array and arrayminus passes through (asymmetric error bars)" do
      s =
        Scatter.new(
          x: [1, 2, 3],
          y: [4, 5, 6],
          error_y: %{
            type: "data",
            array: [0.5, 0.4, 0.3],
            arrayminus: [0.2, 0.3, 0.1],
            visible: true
          }
        )

      assert s.error_y.type == "data"
      assert s.error_y.array == [0.5, 0.4, 0.3]
      assert s.error_y.arrayminus == [0.2, 0.3, 0.1]
    end

    test "error_y with type percent passes through" do
      s = Scatter.new(x: [1, 2], y: [3, 4], error_y: %{type: "percent", value: 10, visible: true})
      assert s.error_y.type == "percent"
      assert s.error_y.value == 10
    end
  end

  describe "Jason.Encoder" do
    test "type is always present in JSON output" do
      decoded = Scatter.new() |> Jason.encode!() |> Jason.decode!()
      assert decoded["type"] == "scatter"
    end

    test "nil fields are omitted from JSON" do
      decoded = Scatter.new() |> Jason.encode!() |> Jason.decode!()
      # x, y, mode etc. should not appear when nil
      refute Map.has_key?(decoded, "x")
      refute Map.has_key?(decoded, "y")
      refute Map.has_key?(decoded, "mode")
    end

    test "non-nil fields appear in JSON" do
      decoded =
        Scatter.new(x: [1, 2], y: [3, 4], mode: "markers")
        |> Jason.encode!()
        |> Jason.decode!()

      assert decoded["x"] == [1, 2]
      assert decoded["y"] == [3, 4]
      assert decoded["mode"] == "markers"
    end

    test "nested plain map survives encoding" do
      decoded =
        Scatter.new(marker: %{color: "red", size: 10})
        |> Jason.encode!()
        |> Jason.decode!()

      assert decoded["marker"]["color"] == "red"
      assert decoded["marker"]["size"] == 10
    end

    test "nested keyword list is normalised and encodes to valid JSON" do
      decoded =
        Scatter.new(marker: [color: "red", size: 10])
        |> Jason.encode!()
        |> Jason.decode!()

      assert decoded["marker"]["color"] == "red"
      assert decoded["marker"]["size"] == 10
    end

    test "hovertemplate is accepted and serialises to JSON" do
      decoded =
        Scatter.new(hovertemplate: "Price: $%{y:.2f}<extra></extra>")
        |> Jason.encode!()
        |> Jason.decode!()

      assert decoded["hovertemplate"] == "Price: $%{y:.2f}<extra></extra>"
    end

    test "trace integrates correctly inside a Figure JSON" do
      fig = Plotly.Figure.new(data: [Scatter.new(x: [1], y: [2])])
      decoded = fig |> Plotly.Figure.to_json() |> Jason.decode!()
      assert [trace] = decoded["data"]
      assert trace["type"] == "scatter"
      assert trace["x"] == [1]
    end
  end
end

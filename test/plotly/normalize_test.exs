defmodule Plotly.NormalizeTest do
  use ExUnit.Case, async: true

  alias Plotly.Normalize

  describe "deep_normalize/1" do
    test "flat keyword list becomes atom-keyed map" do
      assert Normalize.deep_normalize(size: 10, color: "red") ==
               %{size: 10, color: "red"}
    end

    test "nested keyword list becomes nested atom-keyed map" do
      assert Normalize.deep_normalize(marker: [size: 10, color: "red"]) ==
               %{marker: %{size: 10, color: "red"}}
    end

    test "deeply nested keyword lists are all converted" do
      input = [font: [family: "Arial", title: [text: "X"]]]
      expected = %{font: %{family: "Arial", title: %{text: "X"}}}
      assert Normalize.deep_normalize(input) == expected
    end

    test "plain map values are recursed into" do
      assert Normalize.deep_normalize(%{xaxis: [title: "X"]}) ==
               %{xaxis: %{title: "X"}}
    end

    test "non-keyword list (plain array) passes through unchanged" do
      assert Normalize.deep_normalize([1, 2, 3]) == [1, 2, 3]
    end

    test "scalar values pass through unchanged" do
      assert Normalize.deep_normalize("hello") == "hello"
      assert Normalize.deep_normalize(42) == 42
      assert Normalize.deep_normalize(true) == true
      assert Normalize.deep_normalize(nil) == nil
    end

    test "struct values are not unwrapped" do
      struct = %Plotly.Figure{}
      assert Normalize.deep_normalize(struct) == struct
    end

    test "RawJS struct becomes __rawjs__ string-keyed map" do
      assert Normalize.deep_normalize(Plotly.RawJS.new("Plotly.Icons.camera")) ==
               %{"__rawjs__" => "Plotly.Icons.camera"}
    end

    test "RawJS struct nested in map is converted" do
      input = %{icon: Plotly.RawJS.new("Plotly.Icons.camera")}
      assert Normalize.deep_normalize(input) == %{icon: %{"__rawjs__" => "Plotly.Icons.camera"}}
    end

    test "RawJS struct nested in keyword list is converted" do
      input = [icon: Plotly.RawJS.new("Plotly.Icons.camera"), name: "btn"]

      assert Normalize.deep_normalize(input) == %{
               icon: %{"__rawjs__" => "Plotly.Icons.camera"},
               name: "btn"
             }
    end

    test "empty keyword list becomes empty map" do
      assert Normalize.deep_normalize([]) == %{}
    end

    test "mixed: map containing keyword list containing plain list" do
      input = %{axis: [tickvals: [1, 2, 3], title: "X"]}
      expected = %{axis: %{tickvals: [1, 2, 3], title: "X"}}
      assert Normalize.deep_normalize(input) == expected
    end
  end
end

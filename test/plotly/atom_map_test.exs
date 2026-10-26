defmodule Plotly.AtomMapTest do
  use ExUnit.Case, async: true

  alias Plotly.Express

  for selectors <- [[x: :x, y: :y], [x: "x", y: "y"]] do
    test "scatter reads atom-keyed maps with #{inspect(selectors)} selectors" do
      rows = [%{x: 1, y: 4}, %{x: 2, y: nil}, %{x: 3, y: 0}]
      assert [trace] = Express.scatter(rows, unquote(selectors)).data
      assert trace.x == [1, 2, 3]
      assert trace.y == [4, nil, 0]
    end
  end

  test "mixed map key types keep all quiver columns aligned within interleaved groups" do
    rows = [
      %{x: 1, y: 11, u: 21, v: 31, group: "a"},
      %{"x" => 2, "y" => 12, "u" => 22, "v" => 32, "group" => "b"},
      %{"x" => 3, "y" => 13, "u" => 23, "v" => 33, "group" => "a"},
      %{x: 4, y: 14, u: 24, v: 34, group: "b"}
    ]

    for color <- [:group, "group"] do
      figure = Express.quiver(rows, x: :x, y: "y", u: :u, v: "v", color: color)
      assert_vector_groups(figure)
    end
  end

  test "an exact map key wins even when its value is nil or false" do
    rows = [%{"x" => 99, "y" => 88, x: nil, y: false}]
    assert [atoms] = Express.scatter(rows, x: :x, y: :y).data
    assert {atoms.x, atoms.y} == {[nil], [false]}
    assert [strings] = Express.scatter(rows, x: "x", y: "y").data
    assert {strings.x, strings.y} == {[99], [88]}
  end

  test "a missing string column returns nil without creating an atom" do
    column = "plotly_missing_column_#{System.unique_integer([:positive])}"
    assert_raise ArgumentError, fn -> String.to_existing_atom(column) end
    assert [trace] = Express.scatter([%{y: 1}], x: column, y: :y).data
    assert trace.x == [nil]
    assert_raise ArgumentError, fn -> String.to_existing_atom(column) end
  end

  test "keyword-list rows with an existing string selector read the column" do
    assert [trace] = Express.scatter([[x: 1, y: 2]], x: "x", y: "y").data
    assert {trace.x, trace.y} == {[1], [2]}
  end

  test "keyword-list selectors preserve the first matching nil or false value" do
    rows = [[x: nil, x: 99, y: false, y: 88]]

    for selectors <- [[x: :x, y: :y], [x: "x", y: "y"]] do
      assert [trace] = Express.scatter(rows, selectors).data
      assert {trace.x, trace.y} == {[nil], [false]}
    end
  end

  test "keyword-list rows with a missing string column return nil without creating an atom" do
    column = "zz_kw_missing_" <> Integer.to_string(System.unique_integer([:positive]))
    assert_raise ArgumentError, fn -> String.to_existing_atom(column) end
    assert [trace] = Express.scatter([[x: 1]], x: "x", y: column).data
    assert trace.x == [1]
    assert trace.y == [nil]
    assert_raise ArgumentError, fn -> String.to_existing_atom(column) end
  end

  @tag :requires_explorer
  test "Explorer color grouping accepts atom selectors like its coordinate columns" do
    rows = [
      %{x: 1, y: 11, u: 21, v: 31, group: "a"},
      %{x: 2, y: 12, u: 22, v: 32, group: "b"},
      %{x: 3, y: 13, u: 23, v: 33, group: "a"},
      %{x: 4, y: 14, u: 24, v: 34, group: "b"}
    ]

    dataframe = apply(Explorer.DataFrame, :new, [rows])
    figure = Express.quiver(dataframe, x: :x, y: :y, u: :u, v: :v, color: :group)
    assert_vector_groups(figure)
  end

  defp assert_vector_groups(figure) do
    assert length(figure.data) == 2
    traces = Map.new(figure.data, &{&1.name, &1})
    assert Map.keys(traces) |> Enum.sort() == ["a", "b"]

    assert {traces["a"].x, traces["a"].y, traces["a"].u, traces["a"].v} ==
             {[1, 3], [11, 13], [21, 23], [31, 33]}

    assert {traces["b"].x, traces["b"].y, traces["b"].u, traces["b"].v} ==
             {[2, 4], [12, 14], [22, 24], [32, 34]}
  end
end

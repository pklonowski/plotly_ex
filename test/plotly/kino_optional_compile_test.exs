defmodule Plotly.KinoOptionalCompileTest do
  use ExUnit.Case, async: true

  test "smart cell source uses the same top-level optional Kino guard as other Kino modules" do
    source = File.read!(Path.expand("../../lib/plotly/kino/smart_cell.ex", __DIR__))
    ast = Code.string_to_quoted!(source)

    assert {:if, _,
            [
              {{:., _, [{:__aliases__, _, [:Code]}, :ensure_loaded?]}, _,
               [{:__aliases__, _, [:Kino, :JS]}]},
              [do: {:defmodule, _, _}]
            ]} =
             ast
  end

  test "application registers the smart cell only when the register function is exported" do
    source = File.read!(Path.expand("../../lib/plotly/application.ex", __DIR__))

    assert source =~ "function_exported?(Kino.SmartCell, :register, 1)"
    assert source =~ "apply(Kino.SmartCell, :register, [Plotly.Kino.SmartCell])"
  end
end

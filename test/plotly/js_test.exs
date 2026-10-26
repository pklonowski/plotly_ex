defmodule Plotly.JSTest do
  use ExUnit.Case, async: true

  @moduletag :js
  @node System.find_executable("node")
  @moduletag skip:
               if(is_nil(@node),
                 do: "Node is unavailable; final acceptance requires Node",
                 else: false
               )

  test "JavaScript adapter and loader behavior" do
    files = Path.wildcard("test/js/*.test.mjs")
    assert files != []
    {output, status} = System.cmd(@node, ["--test" | files], stderr_to_stdout: true)
    assert status == 0, output
  end
end

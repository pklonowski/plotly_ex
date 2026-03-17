defmodule Plotly.CodegenTest do
  use ExUnit.Case, async: true

  @schema_path "priv/schema/plotly_schema.json"

  test "schema file exists and is valid JSON" do
    assert File.exists?(@schema_path)
    content = File.read!(@schema_path)
    assert {:ok, schema} = Jason.decode(content)
    assert is_map(schema)
  end

  test "schema contains expected trace type keys" do
    schema = @schema_path |> File.read!() |> Jason.decode!()
    # These trace types must be derivable from the schema
    for trace <- ~w[scatter bar pie histogram box] do
      # Each trace has at least one child property key like "scatter.x"
      child_keys = Map.keys(schema) |> Enum.filter(&String.starts_with?(&1, trace <> "."))
      assert child_keys != [], "Expected child keys for trace: #{trace}"
    end
  end

  test "generator derives correct field names for scatter" do
    schema = @schema_path |> File.read!() |> Jason.decode!()
    fields = Mix.Tasks.Plotly.Gen.trace_fields(schema, "scatter")
    # These are known scatter properties
    assert :x in fields
    assert :y in fields
    assert :mode in fields
    assert :name in fields
    assert :marker in fields
  end

  test "generator produces valid Elixir source for scatter" do
    schema = @schema_path |> File.read!() |> Jason.decode!()
    source = Mix.Tasks.Plotly.Gen.generate_trace_module(schema, "scatter")
    assert source =~ "defmodule Plotly.Scatter"
    assert source =~ ~s[type: "scatter"]
    assert source =~ "defimpl Jason.Encoder"
    assert source =~ "def new"
  end

  test "generator lists all expected trace type names" do
    schema = @schema_path |> File.read!() |> Jason.decode!()
    names = Mix.Tasks.Plotly.Gen.trace_names(schema)
    assert "scatter" in names
    assert "bar" in names
    assert "pie" in names
    assert "histogram" in names
    # layout is NOT a trace
    refute "layout" in names
  end
end

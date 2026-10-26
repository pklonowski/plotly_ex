defmodule Plotly.CodegenTest do
  use ExUnit.Case, async: true

  @schema_path "priv/schema/plotly_schema.json"

  test "schema is the unmodified plotly.py 7.1.0 validator file" do
    digest = :crypto.hash(:sha256, File.read!(@schema_path)) |> Base.encode16(case: :lower)
    assert digest == "38f0866fdc77fd4cc202465ddcc30d45c8395d42839a6283bbf500e8e8554db5"
  end

  test "v4 trace inventory adds quiver and removes mapbox traces" do
    names = @schema_path |> File.read!() |> Jason.decode!() |> Mix.Tasks.Plotly.Gen.trace_names()
    assert "quiver" in names
    assert length(names) == 48
    refute Enum.any?(names, &(&1 in ~w(scattermapbox choroplethmapbox densitymapbox)))
  end

  @tag :tmp_dir
  test "regeneration removes obsolete generated files and preserves handwritten files", %{
    tmp_dir: tmp_dir
  } do
    Code.ensure_loaded!(Mix.Tasks.Plotly.Gen)
    assert function_exported?(Mix.Tasks.Plotly.Gen, :stale_files, 2)
    schema_path = Path.join(tmp_dir, "schema.json")
    traces_dir = Path.join(tmp_dir, "traces")
    layout_path = Path.join(tmp_dir, "layout.ex")
    args = ["--schema", schema_path, "--traces-dir", traces_dir, "--layout", layout_path]

    File.write!(
      schema_path,
      Jason.encode!(%{"alpha.x" => %{}, "beta.y" => %{}, "layout.width" => %{}})
    )

    ExUnit.CaptureIO.capture_io(fn -> Mix.Tasks.Plotly.Gen.run(args) end)
    alpha_path = Path.join(traces_dir, "alpha.ex")
    beta_path = Path.join(traces_dir, "beta.ex")
    hand_path = Path.join(traces_dir, "hand.ex")
    File.write!(hand_path, "defmodule Handwritten do\nend\n")
    assert File.read!(beta_path) =~ "# THIS FILE IS AUTO-GENERATED — do not edit by hand."
    assert Mix.Tasks.Plotly.Gen.stale_files(traces_dir, ["alpha"]) == [beta_path]

    File.write!(schema_path, Jason.encode!(%{"alpha.x" => %{}, "layout.width" => %{}}))
    output = ExUnit.CaptureIO.capture_io(fn -> Mix.Tasks.Plotly.Gen.run(args) end)
    assert output =~ "Removed #{beta_path}"
    refute File.exists?(beta_path)
    assert File.exists?(alpha_path)
    assert File.read!(hand_path) == "defmodule Handwritten do\nend\n"
    assert File.read!(layout_path) =~ "defmodule Plotly.Layout"

    before = File.read!(alpha_path)
    ExUnit.CaptureIO.capture_io(fn -> Mix.Tasks.Plotly.Gen.run(args) end)
    assert File.read!(alpha_path) == before
    assert Mix.Tasks.Plotly.Gen.stale_files(traces_dir, ["alpha"]) == []
  end

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

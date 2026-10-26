defmodule Mix.Tasks.Plotly.Docs do
  @moduledoc "Generate docs with published package references in notebook Mix.install blocks."
  use Mix.Task

  @shortdoc "Generate docs (replaces local plotly_ex path with hex dep in notebooks)"

  # Matches both {:plotly_ex, path: Path.join(__DIR__, "..")}
  # and           {:plotly_ex, path: Path.join(__DIR__, "../..")}
  @local_dep_pattern ~r/\{:plotly_ex, path: Path\.join\(__DIR__, "\.\..*?"\)\}/
  @hex_dep ~s({:plotly_ex, "~> 0.1"})

  @impl Mix.Task
  def run(args) do
    notebooks = Path.wildcard("notebooks/*.livemd")

    originals =
      Map.new(notebooks, fn path ->
        {path, File.read!(path)}
      end)

    try do
      Enum.each(originals, fn {path, content} ->
        patched = String.replace(content, @local_dep_pattern, @hex_dep)
        if patched != content, do: File.write!(path, patched)
      end)

      Mix.Task.run("docs", args)
    after
      Enum.each(originals, fn {path, original} ->
        File.write!(path, original)
      end)
    end
  end
end

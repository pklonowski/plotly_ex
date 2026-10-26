defmodule Plotly.VersionGuardTest do
  use ExUnit.Case, async: true

  @roots ["lib", "priv/static", "priv/plotly_js"]

  test "README uses the compatible Plotly.js version" do
    readme = File.read!("README.md")
    refute readme =~ "3.6.0"
    assert readme =~ "plotly.js #{Plotly.PlotlyJS.compatible_version()}"
  end

  test "no stale plotly.js version strings remain in source" do
    offenders =
      @roots
      |> Enum.flat_map(fn root ->
        Path.wildcard(Path.join(root, "**/*.{ex,js}"))
      end)
      |> Enum.filter(fn path ->
        # skip the minified bundle itself
        not String.ends_with?(path, "plotly.min.js") and
          File.read!(path) =~ ~r/2\.35\.2|3\.3\.1|3\.6\.0/
      end)

    assert offenders == [], "stale plotly.js versions found in: #{inspect(offenders)}"
  end
end

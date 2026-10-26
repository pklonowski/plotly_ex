defmodule Plotly.RemovedTracesTest do
  use ExUnit.Case, async: true

  test "removed constructors provide migration instructions and deprecation metadata" do
    for {module, replacement} <- [
          {Plotly.Scattermapbox, Plotly.Scattermap},
          {Plotly.Choroplethmapbox, Plotly.Choroplethmap},
          {Plotly.Densitymapbox, Plotly.Densitymap}
        ] do
      for args <- [[], [[lat: [1]]], [%{lat: [1]}]] do
        error = assert_raise ArgumentError, fn -> apply(module, :new, args) end
        assert error.message =~ "removed in plotly.js v4"
        assert error.message =~ "Use #{inspect(replacement)}"
        assert error.message =~ "layout.mapbox to layout.map"
      end

      assert {:docs_v1, _, _, _, _, metadata, _} = Code.fetch_docs(module)
      assert metadata.deprecated =~ inspect(replacement)
    end
  end
end

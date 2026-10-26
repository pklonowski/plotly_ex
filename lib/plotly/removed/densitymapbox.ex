defmodule Plotly.Densitymapbox do
  @moduledoc "Migration stub for the trace removed in plotly.js v4."
  @moduledoc deprecated: "Use Plotly.Densitymap"

  @doc "Raises with instructions for migrating to Plotly.Densitymap."
  def new(_opts \\ []) do
    raise ArgumentError,
          "Plotly.Densitymapbox was removed in plotly.js v4. Use Plotly.Densitymap instead, " <>
            "and rename layout.mapbox to layout.map (map styles need no access token)."
  end
end

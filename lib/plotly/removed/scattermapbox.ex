defmodule Plotly.Scattermapbox do
  @moduledoc "Migration stub for the trace removed in plotly.js v4."
  @moduledoc deprecated: "Use Plotly.Scattermap"

  @doc "Raises with instructions for migrating to Plotly.Scattermap."
  def new(_opts \\ []) do
    raise ArgumentError,
          "Plotly.Scattermapbox was removed in plotly.js v4. Use Plotly.Scattermap instead, " <>
            "and rename layout.mapbox to layout.map (map styles need no access token)."
  end
end

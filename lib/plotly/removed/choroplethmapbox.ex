defmodule Plotly.Choroplethmapbox do
  @moduledoc "Migration stub for the trace removed in plotly.js v4."
  @moduledoc deprecated: "Use Plotly.Choroplethmap"

  @doc "Raises with instructions for migrating to Plotly.Choroplethmap."
  def new(_opts \\ []) do
    raise ArgumentError,
          "Plotly.Choroplethmapbox was removed in plotly.js v4. Use Plotly.Choroplethmap instead, " <>
            "and rename layout.mapbox to layout.map (map styles need no access token)."
  end
end

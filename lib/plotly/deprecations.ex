defmodule Plotly.Deprecations do
  @moduledoc false

  @removed_config_keys ~w(showLink linkText sendData showSources showEditInChartStudio mapboxAccessToken)a

  def warn_removed_config(config) when is_list(config),
    do: warn_removed_config(Map.new(config))

  def warn_removed_config(config) when is_map(config) do
    removed =
      Enum.filter(@removed_config_keys, fn key ->
        Map.has_key?(config, key) or Map.has_key?(config, Atom.to_string(key))
      end)

    if removed != [] do
      IO.warn(
        "plotly_ex: config keys #{inspect(removed)} were removed in plotly.js v4 and are ignored. " <>
          "Remove them from your config."
      )
    end

    :ok
  end

  def warn_removed_config(_config), do: :ok

  def warn_removed_layout(layout) when is_list(layout),
    do: warn_removed_layout(Map.new(layout))

  def warn_removed_layout(layout) when is_map(layout) do
    if Map.has_key?(layout, :mapbox) or Map.has_key?(layout, "mapbox") do
      IO.warn(
        "plotly_ex: layout.mapbox was removed in plotly.js v4; use layout.map " <>
          "(with Plotly.Scattermap/Choroplethmap/Densitymap)."
      )
    end

    :ok
  end

  def warn_removed_layout(_layout), do: :ok
end

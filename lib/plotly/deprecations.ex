defmodule Plotly.Deprecations do
  @moduledoc false

  @chart_studio_keys [
    :plotlyServerURL,
    :showLink,
    :linkText,
    :showEditInChartStudio,
    :showSendToCloud,
    :sendData
  ]

  @chart_studio_string_keys Enum.map(@chart_studio_keys, &Atom.to_string/1)

  def warn_chart_studio(config) when is_list(config),
    do: warn_chart_studio(Map.new(config))

  def warn_chart_studio(config) when is_map(config) do
    if chart_studio_config?(config) do
      IO.warn("""
      plotly_ex: Chart Studio integration is deprecated and no longer supported.
      Remove :plotlyServerURL, :showLink, :linkText, :showEditInChartStudio, \
      :showSendToCloud, and :sendData from your config.
      """)
    end

    :ok
  end

  def warn_chart_studio(_config), do: :ok

  defp chart_studio_config?(config) do
    keys = Map.keys(config)
    Enum.any?(keys, &(&1 in @chart_studio_keys or &1 in @chart_studio_string_keys))
  end
end

defmodule Plotly.Normalize do
  @moduledoc """
  Utility for normalising keyword lists to atom-keyed maps before JSON encoding.

  `deep_normalize/1` recursively converts nonempty keyword lists into
  an atom-keyed map, allowing keyword lists to be used anywhere a nested map
  is accepted in trace attributes or layout values.
  """

  @doc """
  Recursively converts keyword lists to atom-keyed maps.

  - Nonempty keyword lists → `%{atom: value}` maps (recursed into)
  - Empty lists → empty arrays; use `%{}` for an empty object
  - Plain maps (non-struct) → values recursed into
  - Non-keyword lists → elements recursed into
  - `Plotly.RawJS` structs → `%{"__rawjs__" => value}` string-keyed maps
  - Other structs and scalars → returned as-is
  """
  def deep_normalize(%Plotly.RawJS{value: v}), do: %{"__rawjs__" => v}

  def deep_normalize([]), do: []

  def deep_normalize(kw) when is_list(kw) do
    if Keyword.keyword?(kw) do
      Map.new(kw, fn {k, v} -> {k, deep_normalize(v)} end)
    else
      Enum.map(kw, &deep_normalize/1)
    end
  end

  def deep_normalize(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {k, v} -> {k, deep_normalize(v)} end)
  end

  def deep_normalize(val), do: val

  @doc """
  Coerces bare-string 3D scene axis titles to `%{text: title}`.

  Call this on an already-normalized layout map (post `deep_normalize/1`).

  Unlike 2D cartesian `xaxis`/`yaxis`, plotly.js does not default a bare
  string `scene.xaxis.title` (or `scene2`, `scene3`, …) to `%{text: ...}` —
  it silently falls back to the default "x"/"y"/"z" axis label instead of
  raising or rendering the given title.
  """
  def coerce_scene_axis_titles(layout) when is_map(layout) do
    Map.new(layout, fn
      {key, scene} when is_map(scene) ->
        if scene_key?(key), do: {key, coerce_axis_titles(scene)}, else: {key, scene}

      other ->
        other
    end)
  end

  def coerce_scene_axis_titles(layout), do: layout

  defp scene_key?(key), do: key |> to_string() |> String.match?(~r/^scene\d*$/)

  defp coerce_axis_titles(scene) do
    Map.new(scene, fn
      {axis, %{title: title} = opts} when axis in [:xaxis, :yaxis, :zaxis] and is_binary(title) ->
        {axis, %{opts | title: %{text: title}}}

      other ->
        other
    end)
  end
end

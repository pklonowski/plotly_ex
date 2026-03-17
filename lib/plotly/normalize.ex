defmodule Plotly.Normalize do
  @moduledoc """
  Utility for normalising keyword lists to atom-keyed maps before JSON encoding.

  `deep_normalize/1` recursively converts any keyword list it encounters into
  an atom-keyed map, allowing keyword lists to be used anywhere a nested map
  is accepted in trace attributes or layout values.
  """

  @doc """
  Recursively converts keyword lists to atom-keyed maps.

  - Keyword lists → `%{atom: value}` maps (recursed into)
  - Plain maps (non-struct) → values recursed into
  - Non-keyword lists → elements recursed into
  - `Plotly.RawJS` structs → `%{"__rawjs__" => value}` string-keyed maps
  - Other structs and scalars → returned as-is
  """
  def deep_normalize(%Plotly.RawJS{value: v}), do: %{"__rawjs__" => v}

  def deep_normalize(kw) when is_list(kw) do
    if kw == [] or Keyword.keyword?(kw) do
      Map.new(kw, fn {k, v} -> {k, deep_normalize(v)} end)
    else
      Enum.map(kw, &deep_normalize/1)
    end
  end

  def deep_normalize(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {k, v} -> {k, deep_normalize(v)} end)
  end

  def deep_normalize(val), do: val
end

defmodule Plotly.Templates do
  @moduledoc """
  Bundled named templates, expanded by `Plotly.Figure.to_render_json/1`.

  The definitions come from Plotly.py and work without a browser template
  registry. Names may be strings or atoms. Combine templates with `+`
  (`"plotly_dark+presentation"`): they deep-merge left to right, later ones
  winning. Inline template maps pass through unchanged. An unknown name (or
  unknown part of a combined name) logs a warning and is skipped, so the chart
  renders without it; faithful figure JSON retains the original name.
  """

  require Logger

  @templates (for path <- Path.wildcard(Path.expand("../../priv/templates/*.json", __DIR__)),
                  into: %{"none" => %{}} do
                @external_resource path
                {Path.basename(path, ".json"), Jason.decode!(File.read!(path))}
              end)
  @names @templates |> Map.keys() |> Enum.sort()

  @doc "Names of the bundled templates, including `none` for an empty template."
  def names, do: @names

  @doc false
  def resolve_layout(layout) when is_list(layout), do: resolve_layout(Map.new(layout))

  def resolve_layout(layout) when is_map(layout) do
    Enum.reduce([:template, "template"], layout, fn key, acc ->
      case Map.fetch(acc, key) do
        {:ok, value} -> Map.put(acc, key, resolve(value))
        :error -> acc
      end
    end)
  end

  def resolve_layout(layout), do: layout

  defp resolve(name) when is_atom(name) and name not in [nil, true, false],
    do: resolve(Atom.to_string(name))

  # "a+b" merges bundled templates left to right; unknown parts are skipped.
  defp resolve(name) when is_binary(name) do
    name
    |> String.split("+", trim: true)
    |> Enum.flat_map(fn part ->
      case Map.fetch(@templates, part) do
        {:ok, template} ->
          [template]

        :error ->
          Logger.warning(
            "plotly_ex: unknown Plotly template #{inspect(part)} ignored; supported names: " <>
              Enum.join(@names, ", ") <> ". Use a template map for custom defaults."
          )

          []
      end
    end)
    |> Enum.reduce(%{}, &merge(&2, &1))
  end

  defp resolve(template), do: template

  @doc false
  # Maps deep-merge; lists of maps (per-trace defaults) merge element-wise,
  # keeping the longer list's extra elements; any other right value wins.
  def merge(left, right) when is_map(left) and is_map(right) do
    Map.merge(left, right, fn _key, l, r -> merge(l, r) end)
  end

  def merge(left, right) when is_list(left) and is_list(right) do
    if maps?(left) and maps?(right) do
      max = max(length(left), length(right))

      for i <- 0..(max - 1)//1 do
        case {Enum.at(left, i), Enum.at(right, i)} do
          {l, nil} -> l
          {nil, r} -> r
          {l, r} -> merge(l, r)
        end
      end
    else
      right
    end
  end

  def merge(_left, right), do: right

  defp maps?(list), do: list != [] and Enum.all?(list, &is_map/1)
end

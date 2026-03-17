# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Treemap do
  @moduledoc """
  Plotly Treemap trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly treemap reference](https://plotly.com/javascript/reference/treemap/) for full descriptions.

  - `:branchvalues` — one of: "remainder" | "total"
  - `:count` — flags: "branches" | "leaves"
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:domain` — map (nested properties)
  - `:hoverinfo` — flags: "label" | "text" | "value" | "name" | "current path" | "percent root" | "percent entry" | "percent parent" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:insidetextfont` — map (nested properties)
  - `:labels` — data array
  - `:labelssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:level` — any
  - `:marker` — map (nested properties)
  - `:maxdepth` — integer
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:outsidetextfont` — map (nested properties)
  - `:parents` — data array
  - `:parentssrc` — any
  - `:pathbar` — map (nested properties)
  - `:root` — map (nested properties)
  - `:sort` — boolean
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "current path" | "percent root" | "percent entry" | "percent parent" | "none"
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:textsrc` — any
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:texttemplatesrc` — any
  - `:tiling` — map (nested properties)
  - `:uid` — string
  - `:uirevision` — any
  - `:values` — data array
  - `:valuessrc` — any
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :branchvalues,
    :count,
    :customdata,
    :customdatasrc,
    :domain,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :hovertext,
    :hovertextsrc,
    :ids,
    :idssrc,
    :insidetextfont,
    :labels,
    :labelssrc,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :level,
    :marker,
    :maxdepth,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :outsidetextfont,
    :parents,
    :parentssrc,
    :pathbar,
    :root,
    :sort,
    :stream,
    :text,
    :textfont,
    :textinfo,
    :textposition,
    :textsrc,
    :texttemplate,
    :texttemplatefallback,
    :texttemplatesrc,
    :tiling,
    :uid,
    :uirevision,
    :values,
    :valuessrc,
    :visible,
    type: "treemap"
  ]

  @doc "Rectangular hierarchy chart (nested rectangles). Construct a Treemap trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Treemap do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

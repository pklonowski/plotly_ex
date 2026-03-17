# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Sunburst do
  @moduledoc """
  Plotly Sunburst trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly sunburst reference](https://plotly.com/javascript/reference/sunburst/) for full descriptions.

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
  - `:insidetextorientation` — one of: "horizontal" | "radial" | "tangential" | "auto"
  - `:labels` — data array
  - `:labelssrc` — any
  - `:leaf` — map (nested properties)
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
  - `:root` — map (nested properties)
  - `:rotation` — number (angle in degrees)
  - `:sort` — boolean
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "current path" | "percent root" | "percent entry" | "percent parent" | "none"
  - `:textsrc` — any
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:texttemplatesrc` — any
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
    :insidetextorientation,
    :labels,
    :labelssrc,
    :leaf,
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
    :root,
    :rotation,
    :sort,
    :stream,
    :text,
    :textfont,
    :textinfo,
    :textsrc,
    :texttemplate,
    :texttemplatefallback,
    :texttemplatesrc,
    :uid,
    :uirevision,
    :values,
    :valuessrc,
    :visible,
    type: "sunburst"
  ]

  @doc "Multi-level radial hierarchy chart. Construct a Sunburst trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Sunburst do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

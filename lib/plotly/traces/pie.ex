# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Pie do
  @moduledoc """
  Plotly Pie trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly pie reference](https://plotly.com/javascript/reference/pie/) for full descriptions.

  - `:automargin` — boolean
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:direction` — one of: "clockwise" | "counterclockwise"
  - `:dlabel` — number
  - `:domain` — map (nested properties)
  - `:hole` — number, 0–1
  - `:hoverinfo` — flags: "label" | "text" | "value" | "percent" | "name" | "all" | "none" | "skip"
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
  - `:label0` — number
  - `:labels` — data array
  - `:labelssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendsrc` — any
  - `:legendwidth` — number, 0
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:outsidetextfont` — map (nested properties)
  - `:pull` — number, 0–1
  - `:pullsrc` — any
  - `:rotation` — number (angle in degrees)
  - `:scalegroup` — string
  - `:showlegend` — boolean
  - `:showlegendsrc` — any
  - `:sort` — boolean
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "percent" | "none"
  - `:textposition` — one of: "inside" | "outside" | "auto" | "none"
  - `:textpositionsrc` — any
  - `:textsrc` — any
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:texttemplatesrc` — any
  - `:title` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:values` — data array
  - `:valuessrc` — any
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :automargin,
    :customdata,
    :customdatasrc,
    :direction,
    :dlabel,
    :domain,
    :hole,
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
    :label0,
    :labels,
    :labelssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendsrc,
    :legendwidth,
    :marker,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :outsidetextfont,
    :pull,
    :pullsrc,
    :rotation,
    :scalegroup,
    :showlegend,
    :showlegendsrc,
    :sort,
    :stream,
    :text,
    :textfont,
    :textinfo,
    :textposition,
    :textpositionsrc,
    :textsrc,
    :texttemplate,
    :texttemplatefallback,
    :texttemplatesrc,
    :title,
    :uid,
    :uirevision,
    :values,
    :valuessrc,
    :visible,
    type: "pie"
  ]

  @doc "Circular proportional chart. Construct a Pie trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Pie do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

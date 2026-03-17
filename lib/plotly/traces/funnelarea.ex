# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Funnelarea do
  @moduledoc """
  Plotly Funnelarea trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly funnelarea reference](https://plotly.com/javascript/reference/funnelarea/) for full descriptions.

  - `:aspectratio` — number, 0
  - `:baseratio` — number, 0–1
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:dlabel` — number
  - `:domain` — map (nested properties)
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
  - `:label0` — number
  - `:labels` — data array
  - `:labelssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:scalegroup` — string
  - `:showlegend` — boolean
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "percent" | "none"
  - `:textposition` — one of: "inside" | "none"
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
    :aspectratio,
    :baseratio,
    :customdata,
    :customdatasrc,
    :dlabel,
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
    :label0,
    :labels,
    :labelssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :marker,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :scalegroup,
    :showlegend,
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
    type: "funnelarea"
  ]

  @doc "Construct a Funnelarea trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Funnelarea do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

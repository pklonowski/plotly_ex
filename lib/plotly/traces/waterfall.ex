# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Waterfall do
  @moduledoc """
  Plotly Waterfall trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly waterfall reference](https://plotly.com/javascript/reference/waterfall/) for full descriptions.

  - `:alignmentgroup` — string
  - `:base` — number
  - `:cliponaxis` — boolean
  - `:connector` — map (nested properties)
  - `:constraintext` — one of: "inside" | "outside" | "both" | "none"
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:decreasing` — map (nested properties)
  - `:dx` — number
  - `:dy` — number
  - `:hoverinfo` — flags: "name" | "x" | "y" | "text" | "initial" | "delta" | "final" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:increasing` — map (nested properties)
  - `:insidetextanchor` — one of: "end" | "middle" | "start"
  - `:insidetextfont` — map (nested properties)
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:measure` — data array
  - `:measuresrc` — any
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:offset` — number
  - `:offsetgroup` — string
  - `:offsetsrc` — any
  - `:opacity` — number, 0–1
  - `:orientation` — one of: "v" | "h"
  - `:outsidetextfont` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:stream` — map (nested properties)
  - `:text` — string
  - `:textangle` — number (angle in degrees)
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "initial" | "delta" | "final" | "none"
  - `:textposition` — one of: "inside" | "outside" | "auto" | "none"
  - `:textpositionsrc` — any
  - `:textsrc` — any
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:texttemplatesrc` — any
  - `:totals` — map (nested properties)
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:width` — number, 0
  - `:widthsrc` — any
  - `:x` — data array
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:xhoverformat` — string
  - `:xperiod` — any
  - `:xperiod0` — any
  - `:xperiodalignment` — one of: "start" | "middle" | "end"
  - `:xsrc` — any
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:yhoverformat` — string
  - `:yperiod` — any
  - `:yperiod0` — any
  - `:yperiodalignment` — one of: "start" | "middle" | "end"
  - `:ysrc` — any
  - `:zorder` — integer
  """

  defstruct [
    :alignmentgroup,
    :base,
    :cliponaxis,
    :connector,
    :constraintext,
    :customdata,
    :customdatasrc,
    :decreasing,
    :dx,
    :dy,
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
    :increasing,
    :insidetextanchor,
    :insidetextfont,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :measure,
    :measuresrc,
    :meta,
    :metasrc,
    :name,
    :offset,
    :offsetgroup,
    :offsetsrc,
    :opacity,
    :orientation,
    :outsidetextfont,
    :selectedpoints,
    :showlegend,
    :stream,
    :text,
    :textangle,
    :textfont,
    :textinfo,
    :textposition,
    :textpositionsrc,
    :textsrc,
    :texttemplate,
    :texttemplatefallback,
    :texttemplatesrc,
    :totals,
    :uid,
    :uirevision,
    :visible,
    :width,
    :widthsrc,
    :x,
    :x0,
    :xaxis,
    :xhoverformat,
    :xperiod,
    :xperiod0,
    :xperiodalignment,
    :xsrc,
    :y,
    :y0,
    :yaxis,
    :yhoverformat,
    :yperiod,
    :yperiod0,
    :yperiodalignment,
    :ysrc,
    :zorder,
    type: "waterfall"
  ]

  @doc "Cumulative chart showing incremental +/- values. Construct a Waterfall trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Waterfall do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

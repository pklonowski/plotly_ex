# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Contour do
  @moduledoc """
  Plotly Contour trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly contour reference](https://plotly.com/javascript/reference/contour/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:autocontour` — boolean
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:connectgaps` — boolean
  - `:contours` — map (nested properties)
  - `:customdata` — data array
  - `:dx` — number
  - `:dy` — number
  - `:fillcolor` — color
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hoverongaps` — boolean
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — data array
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:ncontours` — integer
  - `:opacity` — number, 0–1
  - `:reversescale` — boolean
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:transpose` — boolean
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:xperiod` — any
  - `:xperiod0` — any
  - `:xperiodalignment` — one of: "start" | "middle" | "end"
  - `:xtype` — one of: "array" | "scaled"
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:yhoverformat` — string
  - `:yperiod` — any
  - `:yperiod0` — any
  - `:yperiodalignment` — one of: "start" | "middle" | "end"
  - `:ytype` — one of: "array" | "scaled"
  - `:z` — data array
  - `:zauto` — boolean
  - `:zhoverformat` — string
  - `:zmax` — number
  - `:zmid` — number
  - `:zmin` — number
  - `:zorder` — integer
  """

  defstruct [
    :autocolorscale,
    :autocontour,
    :coloraxis,
    :colorbar,
    :colorscale,
    :connectgaps,
    :contours,
    :customdata,
    :dx,
    :dy,
    :fillcolor,
    :hoverinfo,
    :hoverlabel,
    :hoverongaps,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :meta,
    :name,
    :ncontours,
    :opacity,
    :reversescale,
    :showlegend,
    :showscale,
    :text,
    :textfont,
    :texttemplate,
    :texttemplatefallback,
    :transpose,
    :uid,
    :uirevision,
    :visible,
    :x,
    :x0,
    :xaxis,
    :xcalendar,
    :xhoverformat,
    :xperiod,
    :xperiod0,
    :xperiodalignment,
    :xtype,
    :y,
    :y0,
    :yaxis,
    :ycalendar,
    :yhoverformat,
    :yperiod,
    :yperiod0,
    :yperiodalignment,
    :ytype,
    :z,
    :zauto,
    :zhoverformat,
    :zmax,
    :zmid,
    :zmin,
    :zorder,
    type: "contour"
  ]

  @doc "Construct a Contour trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Contour do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

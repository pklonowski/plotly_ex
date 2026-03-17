# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Heatmap do
  @moduledoc """
  Plotly Heatmap trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly heatmap reference](https://plotly.com/javascript/reference/heatmap/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:connectgaps` — boolean
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:dx` — number
  - `:dy` — number
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hoverongaps` — boolean
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — data array
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:reversescale` — boolean
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textsrc` — any
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
  - `:xgap` — number, 0
  - `:xhoverformat` — string
  - `:xperiod` — any
  - `:xperiod0` — any
  - `:xperiodalignment` — one of: "start" | "middle" | "end"
  - `:xsrc` — any
  - `:xtype` — one of: "array" | "scaled"
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:ygap` — number, 0
  - `:yhoverformat` — string
  - `:yperiod` — any
  - `:yperiod0` — any
  - `:yperiodalignment` — one of: "start" | "middle" | "end"
  - `:ysrc` — any
  - `:ytype` — one of: "array" | "scaled"
  - `:z` — data array
  - `:zauto` — boolean
  - `:zhoverformat` — string
  - `:zmax` — number
  - `:zmid` — number
  - `:zmin` — number
  - `:zorder` — integer
  - `:zsmooth` — one of: "fast" | "best" | false
  - `:zsrc` — any
  """

  defstruct [
    :autocolorscale,
    :coloraxis,
    :colorbar,
    :colorscale,
    :connectgaps,
    :customdata,
    :customdatasrc,
    :dx,
    :dy,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hoverongaps,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :hovertext,
    :hovertextsrc,
    :ids,
    :idssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :reversescale,
    :showlegend,
    :showscale,
    :stream,
    :text,
    :textfont,
    :textsrc,
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
    :xgap,
    :xhoverformat,
    :xperiod,
    :xperiod0,
    :xperiodalignment,
    :xsrc,
    :xtype,
    :y,
    :y0,
    :yaxis,
    :ycalendar,
    :ygap,
    :yhoverformat,
    :yperiod,
    :yperiod0,
    :yperiodalignment,
    :ysrc,
    :ytype,
    :z,
    :zauto,
    :zhoverformat,
    :zmax,
    :zmid,
    :zmin,
    :zorder,
    :zsmooth,
    :zsrc,
    type: "heatmap"
  ]

  @doc "Z-values encoded as colour on a 2D grid. Construct a Heatmap trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Heatmap do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

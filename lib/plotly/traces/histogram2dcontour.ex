# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Histogram2dcontour do
  @moduledoc """
  Plotly Histogram2dcontour trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly histogram2dcontour reference](https://plotly.com/javascript/reference/histogram2dcontour/) for full descriptions.

  - `:autobinx` — boolean
  - `:autobiny` — boolean
  - `:autocolorscale` — boolean
  - `:autocontour` — boolean
  - `:bingroup` — string
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:contours` — map (nested properties)
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:histfunc` — one of: "count" | "sum" | "avg" | "min" | "max"
  - `:histnorm` — one of: "" | "percent" | "probability" | "density" | "probability density"
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:nbinsx` — integer
  - `:nbinsy` — integer
  - `:ncontours` — integer
  - `:opacity` — number, 0–1
  - `:reversescale` — boolean
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:stream` — map (nested properties)
  - `:textfont` — map (nested properties)
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xaxis` — string (subplot id)
  - `:xbingroup` — string
  - `:xbins` — map (nested properties)
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:xsrc` — any
  - `:y` — data array
  - `:yaxis` — string (subplot id)
  - `:ybingroup` — string
  - `:ybins` — map (nested properties)
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:yhoverformat` — string
  - `:ysrc` — any
  - `:z` — data array
  - `:zauto` — boolean
  - `:zhoverformat` — string
  - `:zmax` — number
  - `:zmid` — number
  - `:zmin` — number
  - `:zsrc` — any
  """

  defstruct [
    :autobinx,
    :autobiny,
    :autocolorscale,
    :autocontour,
    :bingroup,
    :coloraxis,
    :colorbar,
    :colorscale,
    :contours,
    :customdata,
    :customdatasrc,
    :histfunc,
    :histnorm,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :ids,
    :idssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :marker,
    :meta,
    :metasrc,
    :name,
    :nbinsx,
    :nbinsy,
    :ncontours,
    :opacity,
    :reversescale,
    :showlegend,
    :showscale,
    :stream,
    :textfont,
    :texttemplate,
    :texttemplatefallback,
    :uid,
    :uirevision,
    :visible,
    :x,
    :xaxis,
    :xbingroup,
    :xbins,
    :xcalendar,
    :xhoverformat,
    :xsrc,
    :y,
    :yaxis,
    :ybingroup,
    :ybins,
    :ycalendar,
    :yhoverformat,
    :ysrc,
    :z,
    :zauto,
    :zhoverformat,
    :zmax,
    :zmid,
    :zmin,
    :zsrc,
    type: "histogram2dcontour"
  ]

  @doc "Construct a Histogram2dcontour trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Histogram2dcontour do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

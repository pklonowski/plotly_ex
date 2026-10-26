# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Histogram do
  @moduledoc """
  Plotly Histogram trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly histogram reference](https://plotly.com/javascript/reference/histogram/) for full descriptions.

  - `:alignmentgroup` — string
  - `:autobinx` — boolean
  - `:autobiny` — boolean
  - `:bingroup` — string
  - `:cliponaxis` — boolean
  - `:constraintext` — one of: "inside" | "outside" | "both" | "none"
  - `:cumulative` — map (nested properties)
  - `:customdata` — data array
  - `:error_x` — map (nested properties)
  - `:error_y` — map (nested properties)
  - `:histfunc` — one of: "count" | "sum" | "avg" | "min" | "max"
  - `:histnorm` — one of: "" | "percent" | "probability" | "density" | "probability density"
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:insidetextanchor` — one of: "end" | "middle" | "start"
  - `:insidetextfont` — map (nested properties)
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:nbinsx` — integer
  - `:nbinsy` — integer
  - `:offsetgroup` — string
  - `:opacity` — number, 0–1
  - `:orientation` — one of: "v" | "h"
  - `:outsidetextfont` — map (nested properties)
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:text` — string
  - `:textangle` — number (angle in degrees)
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "inside" | "outside" | "auto" | "none"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xaxis` — string (subplot id)
  - `:xbins` — map (nested properties)
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:y` — data array
  - `:yaxis` — string (subplot id)
  - `:ybins` — map (nested properties)
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:yhoverformat` — string
  - `:zorder` — integer
  """

  defstruct [
    :alignmentgroup,
    :autobinx,
    :autobiny,
    :bingroup,
    :cliponaxis,
    :constraintext,
    :cumulative,
    :customdata,
    :error_x,
    :error_y,
    :histfunc,
    :histnorm,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :insidetextanchor,
    :insidetextfont,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :marker,
    :meta,
    :name,
    :nbinsx,
    :nbinsy,
    :offsetgroup,
    :opacity,
    :orientation,
    :outsidetextfont,
    :selected,
    :selectedpoints,
    :showlegend,
    :text,
    :textangle,
    :textfont,
    :textposition,
    :texttemplate,
    :texttemplatefallback,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    :x,
    :xaxis,
    :xbins,
    :xcalendar,
    :xhoverformat,
    :y,
    :yaxis,
    :ybins,
    :ycalendar,
    :yhoverformat,
    :zorder,
    type: "histogram"
  ]

  @doc "Distribution of a numeric variable, auto-binned. Construct a Histogram trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Histogram do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

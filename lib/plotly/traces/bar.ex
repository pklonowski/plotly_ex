# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Bar do
  @moduledoc """
  Plotly Bar trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly bar reference](https://plotly.com/javascript/reference/bar/) for full descriptions.

  - `:alignmentgroup` — string
  - `:base` — any
  - `:cliponaxis` — boolean
  - `:constraintext` — one of: "inside" | "outside" | "both" | "none"
  - `:customdata` — data array
  - `:dx` — number
  - `:dy` — number
  - `:error_x` — map (nested properties)
  - `:error_y` — map (nested properties)
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
  - `:offset` — number
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
  - `:width` — number, 0
  - `:x` — data array
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:xperiod` — any
  - `:xperiod0` — any
  - `:xperiodalignment` — one of: "start" | "middle" | "end"
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:yhoverformat` — string
  - `:yperiod` — any
  - `:yperiod0` — any
  - `:yperiodalignment` — one of: "start" | "middle" | "end"
  - `:zorder` — integer
  """

  defstruct [
    :alignmentgroup,
    :base,
    :cliponaxis,
    :constraintext,
    :customdata,
    :dx,
    :dy,
    :error_x,
    :error_y,
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
    :offset,
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
    :width,
    :x,
    :x0,
    :xaxis,
    :xcalendar,
    :xhoverformat,
    :xperiod,
    :xperiod0,
    :xperiodalignment,
    :y,
    :y0,
    :yaxis,
    :ycalendar,
    :yhoverformat,
    :yperiod,
    :yperiod0,
    :yperiodalignment,
    :zorder,
    type: "bar"
  ]

  @doc "Vertical or horizontal bar chart. Construct a Bar trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Bar do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

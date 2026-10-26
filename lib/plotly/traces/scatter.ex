# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Scatter do
  @moduledoc """
  Plotly Scatter trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly scatter reference](https://plotly.com/javascript/reference/scatter/) for full descriptions.

  - `:alignmentgroup` — string
  - `:cliponaxis` — boolean
  - `:connectgaps` — boolean
  - `:customdata` — data array
  - `:dx` — number
  - `:dy` — number
  - `:error_x` — map (nested properties)
  - `:error_y` — map (nested properties)
  - `:fill` — one of: "none" | "tozeroy" | "tozerox" | "tonexty" | "tonextx" | "toself" | "tonext"
  - `:fillcolor` — color
  - `:fillgradient` — map (nested properties)
  - `:fillpattern` — map (nested properties)
  - `:groupnorm` — one of: "" | "fraction" | "percent"
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hoveron` — flags: "points" | "fills"
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:mode` — flags: "lines" | "markers" | "text" | "none"
  - `:name` — string
  - `:offsetgroup` — string
  - `:opacity` — number, 0–1
  - `:orientation` — one of: "v" | "h"
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:stackgaps` — one of: "infer zero" | "interpolate"
  - `:stackgroup` — string
  - `:text` — string
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
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
    :cliponaxis,
    :connectgaps,
    :customdata,
    :dx,
    :dy,
    :error_x,
    :error_y,
    :fill,
    :fillcolor,
    :fillgradient,
    :fillpattern,
    :groupnorm,
    :hoverinfo,
    :hoverlabel,
    :hoveron,
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
    :marker,
    :meta,
    :mode,
    :name,
    :offsetgroup,
    :opacity,
    :orientation,
    :selected,
    :selectedpoints,
    :showlegend,
    :stackgaps,
    :stackgroup,
    :text,
    :textfont,
    :textposition,
    :texttemplate,
    :texttemplatefallback,
    :uid,
    :uirevision,
    :unselected,
    :visible,
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
    type: "scatter"
  ]

  @doc "X/Y scatter or line chart; mode controls markers vs lines. Construct a Scatter trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Scatter do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

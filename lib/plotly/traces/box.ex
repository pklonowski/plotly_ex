# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Box do
  @moduledoc """
  Plotly Box trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly box reference](https://plotly.com/javascript/reference/box/) for full descriptions.

  - `:alignmentgroup` — string
  - `:boxmean` — one of: true | "sd" | false
  - `:boxpoints` — one of: "all" | "outliers" | "suspectedoutliers" | false
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:dx` — number
  - `:dy` — number
  - `:fillcolor` — color
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hoveron` — flags: "boxes" | "points"
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:jitter` — number, 0–1
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:lowerfence` — data array
  - `:lowerfencesrc` — any
  - `:marker` — map (nested properties)
  - `:mean` — data array
  - `:meansrc` — any
  - `:median` — data array
  - `:mediansrc` — any
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:notched` — boolean
  - `:notchspan` — data array
  - `:notchspansrc` — any
  - `:notchwidth` — number, 0–0.5
  - `:offsetgroup` — string
  - `:opacity` — number, 0–1
  - `:orientation` — one of: "v" | "h"
  - `:pointpos` — number, -2–2
  - `:q1` — data array
  - `:q1src` — any
  - `:q3` — data array
  - `:q3src` — any
  - `:quartilemethod` — one of: "linear" | "exclusive" | "inclusive"
  - `:sd` — data array
  - `:sdmultiple` — number, 0
  - `:sdsrc` — any
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:showwhiskers` — boolean
  - `:sizemode` — one of: "quartiles" | "sd"
  - `:stream` — map (nested properties)
  - `:text` — string
  - `:textsrc` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:upperfence` — data array
  - `:upperfencesrc` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:whiskerwidth` — number, 0–1
  - `:width` — number, 0
  - `:x` — data array
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:xperiod` — any
  - `:xperiod0` — any
  - `:xperiodalignment` — one of: "start" | "middle" | "end"
  - `:xsrc` — any
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:yhoverformat` — string
  - `:yperiod` — any
  - `:yperiod0` — any
  - `:yperiodalignment` — one of: "start" | "middle" | "end"
  - `:ysrc` — any
  - `:zorder` — integer
  """

  defstruct [
    :alignmentgroup,
    :boxmean,
    :boxpoints,
    :customdata,
    :customdatasrc,
    :dx,
    :dy,
    :fillcolor,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hoveron,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :hovertext,
    :hovertextsrc,
    :ids,
    :idssrc,
    :jitter,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :lowerfence,
    :lowerfencesrc,
    :marker,
    :mean,
    :meansrc,
    :median,
    :mediansrc,
    :meta,
    :metasrc,
    :name,
    :notched,
    :notchspan,
    :notchspansrc,
    :notchwidth,
    :offsetgroup,
    :opacity,
    :orientation,
    :pointpos,
    :q1,
    :q1src,
    :q3,
    :q3src,
    :quartilemethod,
    :sd,
    :sdmultiple,
    :sdsrc,
    :selected,
    :selectedpoints,
    :showlegend,
    :showwhiskers,
    :sizemode,
    :stream,
    :text,
    :textsrc,
    :uid,
    :uirevision,
    :unselected,
    :upperfence,
    :upperfencesrc,
    :visible,
    :whiskerwidth,
    :width,
    :x,
    :x0,
    :xaxis,
    :xcalendar,
    :xhoverformat,
    :xperiod,
    :xperiod0,
    :xperiodalignment,
    :xsrc,
    :y,
    :y0,
    :yaxis,
    :ycalendar,
    :yhoverformat,
    :yperiod,
    :yperiod0,
    :yperiodalignment,
    :ysrc,
    :zorder,
    type: "box"
  ]

  @doc "Box-and-whisker plot: median, quartiles, outliers. Construct a Box trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Box do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Surface do
  @moduledoc """
  Plotly Surface trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly surface reference](https://plotly.com/javascript/reference/surface/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:cauto` — boolean
  - `:cmax` — number
  - `:cmid` — number
  - `:cmin` — number
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:connectgaps` — boolean
  - `:contours` — map (nested properties)
  - `:customdata` — data array
  - `:hidesurface` — boolean
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:lighting` — map (nested properties)
  - `:lightposition` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:opacityscale` — any
  - `:reversescale` — boolean
  - `:scene` — string (subplot id)
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:surfacecolor` — data array
  - `:text` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:y` — data array
  - `:ycalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:yhoverformat` — string
  - `:z` — data array
  - `:zcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:zhoverformat` — string
  """

  defstruct [
    :autocolorscale,
    :cauto,
    :cmax,
    :cmid,
    :cmin,
    :coloraxis,
    :colorbar,
    :colorscale,
    :connectgaps,
    :contours,
    :customdata,
    :hidesurface,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :lighting,
    :lightposition,
    :meta,
    :name,
    :opacity,
    :opacityscale,
    :reversescale,
    :scene,
    :showlegend,
    :showscale,
    :surfacecolor,
    :text,
    :uid,
    :uirevision,
    :visible,
    :x,
    :xcalendar,
    :xhoverformat,
    :y,
    :ycalendar,
    :yhoverformat,
    :z,
    :zcalendar,
    :zhoverformat,
    type: "surface"
  ]

  @doc "3D surface plot from a z-matrix. Construct a Surface trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Surface do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

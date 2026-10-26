# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Mesh3d do
  @moduledoc """
  Plotly Mesh3d trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly mesh3d reference](https://plotly.com/javascript/reference/mesh3d/) for full descriptions.

  - `:alphahull` — number
  - `:autocolorscale` — boolean
  - `:cauto` — boolean
  - `:cmax` — number
  - `:cmid` — number
  - `:cmin` — number
  - `:color` — color
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:contour` — map (nested properties)
  - `:customdata` — data array
  - `:delaunayaxis` — one of: "x" | "y" | "z"
  - `:facecolor` — data array
  - `:flatshading` — boolean
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:i` — data array
  - `:ids` — data array
  - `:intensity` — data array
  - `:intensitymode` — one of: "vertex" | "cell"
  - `:j` — data array
  - `:k` — data array
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
  - `:reversescale` — boolean
  - `:scene` — string (subplot id)
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:text` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:vertexcolor` — data array
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
    :alphahull,
    :autocolorscale,
    :cauto,
    :cmax,
    :cmid,
    :cmin,
    :color,
    :coloraxis,
    :colorbar,
    :colorscale,
    :contour,
    :customdata,
    :delaunayaxis,
    :facecolor,
    :flatshading,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :i,
    :ids,
    :intensity,
    :intensitymode,
    :j,
    :k,
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
    :reversescale,
    :scene,
    :showlegend,
    :showscale,
    :text,
    :uid,
    :uirevision,
    :vertexcolor,
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
    type: "mesh3d"
  ]

  @doc "Construct a Mesh3d trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Mesh3d do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

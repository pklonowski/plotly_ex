# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Scatter3d do
  @moduledoc """
  Plotly Scatter3d trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly scatter3d reference](https://plotly.com/javascript/reference/scatter3d/) for full descriptions.

  - `:connectgaps` — boolean
  - `:customdata` — data array
  - `:error_x` — map (nested properties)
  - `:error_y` — map (nested properties)
  - `:error_z` — map (nested properties)
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
  - `:line` — map (nested properties)
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:mode` — flags: "lines" | "markers" | "text" | "none"
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:projection` — map (nested properties)
  - `:scene` — string (subplot id)
  - `:showlegend` — boolean
  - `:surfaceaxis` — one of: -1 | 0 | 1 | 2
  - `:surfacecolor` — color
  - `:text` — string
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
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
    :connectgaps,
    :customdata,
    :error_x,
    :error_y,
    :error_z,
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
    :line,
    :marker,
    :meta,
    :mode,
    :name,
    :opacity,
    :projection,
    :scene,
    :showlegend,
    :surfaceaxis,
    :surfacecolor,
    :text,
    :textfont,
    :textposition,
    :texttemplate,
    :texttemplatefallback,
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
    type: "scatter3d"
  ]

  @doc "3D scatter chart using x, y, z axes. Construct a Scatter3d trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Scatter3d do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

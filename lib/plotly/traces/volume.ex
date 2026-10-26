# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Volume do
  @moduledoc """
  Plotly Volume trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly volume reference](https://plotly.com/javascript/reference/volume/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:caps` — map (nested properties)
  - `:cauto` — boolean
  - `:cmax` — number
  - `:cmid` — number
  - `:cmin` — number
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:contour` — map (nested properties)
  - `:customdata` — data array
  - `:flatshading` — boolean
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:isomax` — number
  - `:isomin` — number
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
  - `:slices` — map (nested properties)
  - `:spaceframe` — map (nested properties)
  - `:surface` — map (nested properties)
  - `:text` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:value` — data array
  - `:valuehoverformat` — string
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xhoverformat` — string
  - `:y` — data array
  - `:yhoverformat` — string
  - `:z` — data array
  - `:zhoverformat` — string
  """

  defstruct [
    :autocolorscale,
    :caps,
    :cauto,
    :cmax,
    :cmid,
    :cmin,
    :coloraxis,
    :colorbar,
    :colorscale,
    :contour,
    :customdata,
    :flatshading,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :isomax,
    :isomin,
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
    :slices,
    :spaceframe,
    :surface,
    :text,
    :uid,
    :uirevision,
    :value,
    :valuehoverformat,
    :visible,
    :x,
    :xhoverformat,
    :y,
    :yhoverformat,
    :z,
    :zhoverformat,
    type: "volume"
  ]

  @doc "Construct a Volume trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Volume do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

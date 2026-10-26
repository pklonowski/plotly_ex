# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Cone do
  @moduledoc """
  Plotly Cone trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly cone reference](https://plotly.com/javascript/reference/cone/) for full descriptions.

  - `:anchor` — one of: "tip" | "tail" | "cm" | "center"
  - `:autocolorscale` — boolean
  - `:cauto` — boolean
  - `:cmax` — number
  - `:cmid` — number
  - `:cmin` — number
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:customdata` — data array
  - `:hoverinfo` — flags: "x" | "y" | "z" | "u" | "v" | "w" | "norm" | "text" | "name" | "all" | "none" | "skip"
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
  - `:reversescale` — boolean
  - `:scene` — string (subplot id)
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:sizemode` — one of: "scaled" | "absolute" | "raw"
  - `:sizeref` — number, 0
  - `:text` — string
  - `:u` — data array
  - `:uhoverformat` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:v` — data array
  - `:vhoverformat` — string
  - `:visible` — one of: true | false | "legendonly"
  - `:w` — data array
  - `:whoverformat` — string
  - `:x` — data array
  - `:xhoverformat` — string
  - `:y` — data array
  - `:yhoverformat` — string
  - `:z` — data array
  - `:zhoverformat` — string
  """

  defstruct [
    :anchor,
    :autocolorscale,
    :cauto,
    :cmax,
    :cmid,
    :cmin,
    :coloraxis,
    :colorbar,
    :colorscale,
    :customdata,
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
    :reversescale,
    :scene,
    :showlegend,
    :showscale,
    :sizemode,
    :sizeref,
    :text,
    :u,
    :uhoverformat,
    :uid,
    :uirevision,
    :v,
    :vhoverformat,
    :visible,
    :w,
    :whoverformat,
    :x,
    :xhoverformat,
    :y,
    :yhoverformat,
    :z,
    :zhoverformat,
    type: "cone"
  ]

  @doc "Construct a Cone trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Cone do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Image do
  @moduledoc """
  Plotly Image trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly image reference](https://plotly.com/javascript/reference/image/) for full descriptions.

  - `:colormodel` — one of: "rgb" | "rgba" | "rgba256" | "hsl" | "hsla"
  - `:customdata` — data array
  - `:dx` — number
  - `:dy` — number
  - `:hoverinfo` — flags: "x" | "y" | "z" | "color" | "name" | "text" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — data array
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:source` — string
  - `:text` — data array
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:z` — data array
  - `:zmax` — any
  - `:zmin` — any
  - `:zorder` — integer
  - `:zsmooth` — one of: "fast" | false
  """

  defstruct [
    :colormodel,
    :customdata,
    :dx,
    :dy,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :name,
    :opacity,
    :source,
    :text,
    :uid,
    :uirevision,
    :visible,
    :x0,
    :xaxis,
    :y0,
    :yaxis,
    :z,
    :zmax,
    :zmin,
    :zorder,
    :zsmooth,
    type: "image"
  ]

  @doc "Construct a Image trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Image do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

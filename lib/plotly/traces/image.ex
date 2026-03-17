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
  - `:customdatasrc` — any
  - `:dx` — number
  - `:dy` — number
  - `:hoverinfo` — flags: "x" | "y" | "z" | "color" | "name" | "text" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — data array
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:source` — string
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textsrc` — any
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
  - `:zsrc` — any
  """

  defstruct [
    :colormodel,
    :customdata,
    :customdatasrc,
    :dx,
    :dy,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :hovertext,
    :hovertextsrc,
    :ids,
    :idssrc,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :source,
    :stream,
    :text,
    :textsrc,
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
    :zsrc,
    type: "image"
  ]

  @doc "Construct a Image trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
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

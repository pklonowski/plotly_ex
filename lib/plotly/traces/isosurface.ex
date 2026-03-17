# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Isosurface do
  @moduledoc """
  Plotly Isosurface trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly isosurface reference](https://plotly.com/javascript/reference/isosurface/) for full descriptions.

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
  - `:customdatasrc` — any
  - `:flatshading` — boolean
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
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
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:reversescale` — boolean
  - `:scene` — string (subplot id)
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:slices` — map (nested properties)
  - `:spaceframe` — map (nested properties)
  - `:stream` — map (nested properties)
  - `:surface` — map (nested properties)
  - `:text` — string
  - `:textsrc` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:value` — data array
  - `:valuehoverformat` — string
  - `:valuesrc` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xhoverformat` — string
  - `:xsrc` — any
  - `:y` — data array
  - `:yhoverformat` — string
  - `:ysrc` — any
  - `:z` — data array
  - `:zhoverformat` — string
  - `:zsrc` — any
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
    :customdatasrc,
    :flatshading,
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
    :metasrc,
    :name,
    :opacity,
    :reversescale,
    :scene,
    :showlegend,
    :showscale,
    :slices,
    :spaceframe,
    :stream,
    :surface,
    :text,
    :textsrc,
    :uid,
    :uirevision,
    :value,
    :valuehoverformat,
    :valuesrc,
    :visible,
    :x,
    :xhoverformat,
    :xsrc,
    :y,
    :yhoverformat,
    :ysrc,
    :z,
    :zhoverformat,
    :zsrc,
    type: "isosurface"
  ]

  @doc "Construct a Isosurface trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Isosurface do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

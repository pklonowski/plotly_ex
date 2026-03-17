# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Densitymap do
  @moduledoc """
  Plotly Densitymap trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly densitymap reference](https://plotly.com/javascript/reference/densitymap/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:below` — string
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:hoverinfo` — flags: "lon" | "lat" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:lat` — data array
  - `:latsrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:lon` — data array
  - `:lonsrc` — any
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:radius` — number, 1
  - `:radiussrc` — any
  - `:reversescale` — boolean
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:stream` — map (nested properties)
  - `:subplot` — string (subplot id)
  - `:text` — string
  - `:textsrc` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:z` — data array
  - `:zauto` — boolean
  - `:zmax` — number
  - `:zmid` — number
  - `:zmin` — number
  - `:zsrc` — any
  """

  defstruct [
    :autocolorscale,
    :below,
    :coloraxis,
    :colorbar,
    :colorscale,
    :customdata,
    :customdatasrc,
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
    :lat,
    :latsrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :lon,
    :lonsrc,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :radius,
    :radiussrc,
    :reversescale,
    :showlegend,
    :showscale,
    :stream,
    :subplot,
    :text,
    :textsrc,
    :uid,
    :uirevision,
    :visible,
    :z,
    :zauto,
    :zmax,
    :zmid,
    :zmin,
    :zsrc,
    type: "densitymap"
  ]

  @doc "Construct a Densitymap trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Densitymap do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

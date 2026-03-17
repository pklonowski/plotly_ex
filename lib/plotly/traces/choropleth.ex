# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Choropleth do
  @moduledoc """
  Plotly Choropleth trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly choropleth reference](https://plotly.com/javascript/reference/choropleth/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:featureidkey` — string
  - `:geo` — string (subplot id)
  - `:geojson` — any
  - `:hoverinfo` — flags: "location" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:locationmode` — one of: "ISO-3" | "USA-states" | "country names" | "geojson-id"
  - `:locations` — data array
  - `:locationssrc` — any
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:reversescale` — boolean
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:stream` — map (nested properties)
  - `:text` — string
  - `:textsrc` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
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
    :coloraxis,
    :colorbar,
    :colorscale,
    :customdata,
    :customdatasrc,
    :featureidkey,
    :geo,
    :geojson,
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
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :locationmode,
    :locations,
    :locationssrc,
    :marker,
    :meta,
    :metasrc,
    :name,
    :reversescale,
    :selected,
    :selectedpoints,
    :showlegend,
    :showscale,
    :stream,
    :text,
    :textsrc,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    :z,
    :zauto,
    :zmax,
    :zmid,
    :zmin,
    :zsrc,
    type: "choropleth"
  ]

  @doc "Choropleth map: regions coloured by value. Construct a Choropleth trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Choropleth do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

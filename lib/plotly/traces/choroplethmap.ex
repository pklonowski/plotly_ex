# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Choroplethmap do
  @moduledoc """
  Plotly Choroplethmap trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly choroplethmap reference](https://plotly.com/javascript/reference/choroplethmap/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:below` — string
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:customdata` — data array
  - `:featureidkey` — string
  - `:geojson` — any
  - `:hoverinfo` — flags: "location" | "z" | "text" | "name" | "all" | "none" | "skip"
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
  - `:locations` — data array
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:reversescale` — boolean
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:subplot` — string (subplot id)
  - `:text` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  - `:z` — data array
  - `:zauto` — boolean
  - `:zmax` — number
  - `:zmid` — number
  - `:zmin` — number
  """

  defstruct [
    :autocolorscale,
    :below,
    :coloraxis,
    :colorbar,
    :colorscale,
    :customdata,
    :featureidkey,
    :geojson,
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
    :locations,
    :marker,
    :meta,
    :name,
    :reversescale,
    :selected,
    :selectedpoints,
    :showlegend,
    :showscale,
    :subplot,
    :text,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    :z,
    :zauto,
    :zmax,
    :zmid,
    :zmin,
    type: "choroplethmap"
  ]

  @doc "Construct a Choroplethmap trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Choroplethmap do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

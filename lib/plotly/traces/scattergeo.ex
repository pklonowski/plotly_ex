# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Scattergeo do
  @moduledoc """
  Plotly Scattergeo trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly scattergeo reference](https://plotly.com/javascript/reference/scattergeo/) for full descriptions.

  - `:connectgaps` — boolean
  - `:customdata` — data array
  - `:featureidkey` — string
  - `:fill` — one of: "none" | "toself"
  - `:fillcolor` — color
  - `:geo` — string (subplot id)
  - `:geojson` — any
  - `:hoverinfo` — flags: "lon" | "lat" | "location" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:lat` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:locationmode` — one of: "ISO-3" | "USA-states" | "country names" | "geojson-id"
  - `:locations` — data array
  - `:lon` — data array
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:mode` — flags: "lines" | "markers" | "text" | "none"
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:text` — string
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :connectgaps,
    :customdata,
    :featureidkey,
    :fill,
    :fillcolor,
    :geo,
    :geojson,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :lat,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :locationmode,
    :locations,
    :lon,
    :marker,
    :meta,
    :mode,
    :name,
    :opacity,
    :selected,
    :selectedpoints,
    :showlegend,
    :text,
    :textfont,
    :textposition,
    :texttemplate,
    :texttemplatefallback,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    type: "scattergeo"
  ]

  @doc "Scatter points on a geo projection map. Construct a Scattergeo trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Scattergeo do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

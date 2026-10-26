# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Pie do
  @moduledoc """
  Plotly Pie trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly pie reference](https://plotly.com/javascript/reference/pie/) for full descriptions.

  - `:automargin` — boolean
  - `:customdata` — data array
  - `:direction` — one of: "clockwise" | "counterclockwise"
  - `:dlabel` — number
  - `:domain` — map (nested properties)
  - `:hole` — number, 0–1
  - `:hoverinfo` — flags: "label" | "text" | "value" | "percent" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:insidetextfont` — map (nested properties)
  - `:insidetextorientation` — one of: "horizontal" | "radial" | "tangential" | "auto"
  - `:label0` — number
  - `:labels` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:outsidetextfont` — map (nested properties)
  - `:pull` — number, 0–1
  - `:rotation` — number (angle in degrees)
  - `:scalegroup` — string
  - `:showlegend` — boolean
  - `:sort` — boolean
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "percent" | "none"
  - `:textposition` — one of: "inside" | "outside" | "auto" | "none"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:title` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:values` — data array
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :automargin,
    :customdata,
    :direction,
    :dlabel,
    :domain,
    :hole,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :insidetextfont,
    :insidetextorientation,
    :label0,
    :labels,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :marker,
    :meta,
    :name,
    :opacity,
    :outsidetextfont,
    :pull,
    :rotation,
    :scalegroup,
    :showlegend,
    :sort,
    :text,
    :textfont,
    :textinfo,
    :textposition,
    :texttemplate,
    :texttemplatefallback,
    :title,
    :uid,
    :uirevision,
    :values,
    :visible,
    type: "pie"
  ]

  @doc "Circular proportional chart. Construct a Pie trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Pie do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

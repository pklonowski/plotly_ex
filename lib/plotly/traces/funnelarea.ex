# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Funnelarea do
  @moduledoc """
  Plotly Funnelarea trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly funnelarea reference](https://plotly.com/javascript/reference/funnelarea/) for full descriptions.

  - `:aspectratio` — number, 0
  - `:baseratio` — number, 0–1
  - `:customdata` — data array
  - `:dlabel` — number
  - `:domain` — map (nested properties)
  - `:hoverinfo` — flags: "label" | "text" | "value" | "percent" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:insidetextfont` — map (nested properties)
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
  - `:scalegroup` — string
  - `:showlegend` — boolean
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "percent" | "none"
  - `:textposition` — one of: "inside" | "none"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:title` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:values` — data array
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :aspectratio,
    :baseratio,
    :customdata,
    :dlabel,
    :domain,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :insidetextfont,
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
    :scalegroup,
    :showlegend,
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
    type: "funnelarea"
  ]

  @doc "Construct a Funnelarea trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Funnelarea do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

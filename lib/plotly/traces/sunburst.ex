# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Sunburst do
  @moduledoc """
  Plotly Sunburst trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly sunburst reference](https://plotly.com/javascript/reference/sunburst/) for full descriptions.

  - `:branchvalues` — one of: "remainder" | "total"
  - `:count` — flags: "branches" | "leaves"
  - `:customdata` — data array
  - `:domain` — map (nested properties)
  - `:hoverinfo` — flags: "label" | "text" | "value" | "name" | "current path" | "percent root" | "percent entry" | "percent parent" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:insidetextfont` — map (nested properties)
  - `:insidetextorientation` — one of: "horizontal" | "radial" | "tangential" | "auto"
  - `:labels` — data array
  - `:leaf` — map (nested properties)
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:level` — any
  - `:marker` — map (nested properties)
  - `:maxdepth` — integer
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:outsidetextfont` — map (nested properties)
  - `:parents` — data array
  - `:root` — map (nested properties)
  - `:rotation` — number (angle in degrees)
  - `:sort` — boolean
  - `:text` — data array
  - `:textfont` — map (nested properties)
  - `:textinfo` — flags: "label" | "text" | "value" | "current path" | "percent root" | "percent entry" | "percent parent" | "none"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:values` — data array
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :branchvalues,
    :count,
    :customdata,
    :domain,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :insidetextfont,
    :insidetextorientation,
    :labels,
    :leaf,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :level,
    :marker,
    :maxdepth,
    :meta,
    :name,
    :opacity,
    :outsidetextfont,
    :parents,
    :root,
    :rotation,
    :sort,
    :text,
    :textfont,
    :textinfo,
    :texttemplate,
    :texttemplatefallback,
    :uid,
    :uirevision,
    :values,
    :visible,
    type: "sunburst"
  ]

  @doc "Multi-level radial hierarchy chart. Construct a Sunburst trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Sunburst do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

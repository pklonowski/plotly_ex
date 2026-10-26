# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Sankey do
  @moduledoc """
  Plotly Sankey trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly sankey reference](https://plotly.com/javascript/reference/sankey/) for full descriptions.

  - `:arrangement` — one of: "snap" | "perpendicular" | "freeform" | "fixed"
  - `:customdata` — data array
  - `:direction` — one of: "forward" | "reversed"
  - `:domain` — map (nested properties)
  - `:hoverinfo` — flags: "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:link` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:node` — map (nested properties)
  - `:orientation` — one of: "v" | "h"
  - `:selectedpoints` — any
  - `:textfont` — map (nested properties)
  - `:uid` — string
  - `:uirevision` — any
  - `:valueformat` — string
  - `:valuesuffix` — string
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :arrangement,
    :customdata,
    :direction,
    :domain,
    :hoverinfo,
    :hoverlabel,
    :ids,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :link,
    :meta,
    :name,
    :node,
    :orientation,
    :selectedpoints,
    :textfont,
    :uid,
    :uirevision,
    :valueformat,
    :valuesuffix,
    :visible,
    type: "sankey"
  ]

  @doc "Flow diagram: quantities between source/target nodes. Construct a Sankey trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Sankey do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

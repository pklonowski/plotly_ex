# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Parcats do
  @moduledoc """
  Plotly Parcats trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly parcats reference](https://plotly.com/javascript/reference/parcats/) for full descriptions.

  - `:arrangement` — one of: "perpendicular" | "freeform" | "fixed"
  - `:bundlecolors` — boolean
  - `:counts` — number, 0
  - `:dimensiondefaults` — map (nested properties)
  - `:dimensions` — list of maps (nested properties)
  - `:domain` — map (nested properties)
  - `:hoverinfo` — flags: "count" | "probability" | "all" | "none" | "skip"
  - `:hoveron` — one of: "category" | "color" | "dimension"
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:labelfont` — map (nested properties)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:sortpaths` — one of: "forward" | "backward"
  - `:tickfont` — map (nested properties)
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :arrangement,
    :bundlecolors,
    :counts,
    :dimensiondefaults,
    :dimensions,
    :domain,
    :hoverinfo,
    :hoveron,
    :hovertemplate,
    :hovertemplatefallback,
    :labelfont,
    :legendgrouptitle,
    :legendwidth,
    :line,
    :meta,
    :name,
    :sortpaths,
    :tickfont,
    :uid,
    :uirevision,
    :visible,
    type: "parcats"
  ]

  @doc "Construct a Parcats trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Parcats do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

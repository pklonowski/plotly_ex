# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Splom do
  @moduledoc """
  Plotly Splom trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly splom reference](https://plotly.com/javascript/reference/splom/) for full descriptions.

  - `:customdata` — data array
  - `:diagonal` — map (nested properties)
  - `:dimensiondefaults` — map (nested properties)
  - `:dimensions` — list of maps (nested properties)
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
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
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:showlowerhalf` — boolean
  - `:showupperhalf` — boolean
  - `:text` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  - `:xaxes` — any
  - `:xhoverformat` — string
  - `:yaxes` — any
  - `:yhoverformat` — string
  """

  defstruct [
    :customdata,
    :diagonal,
    :dimensiondefaults,
    :dimensions,
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
    :marker,
    :meta,
    :name,
    :opacity,
    :selected,
    :selectedpoints,
    :showlegend,
    :showlowerhalf,
    :showupperhalf,
    :text,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    :xaxes,
    :xhoverformat,
    :yaxes,
    :yhoverformat,
    type: "splom"
  ]

  @doc "Scatter plot matrix — all pairwise dimension combinations. Construct a Splom trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Splom do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

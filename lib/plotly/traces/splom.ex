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
  - `:customdatasrc` — any
  - `:diagonal` — map (nested properties)
  - `:dimensiondefaults` — map (nested properties)
  - `:dimensions` — list of maps (nested properties)
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
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
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:showlowerhalf` — boolean
  - `:showupperhalf` — boolean
  - `:stream` — map (nested properties)
  - `:text` — string
  - `:textsrc` — any
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
    :customdatasrc,
    :diagonal,
    :dimensiondefaults,
    :dimensions,
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
    :marker,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :selected,
    :selectedpoints,
    :showlegend,
    :showlowerhalf,
    :showupperhalf,
    :stream,
    :text,
    :textsrc,
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
      bad = Keyword.keys(List.wrap(opts)) -- valid
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

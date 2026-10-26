# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Violin do
  @moduledoc """
  Plotly Violin trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly violin reference](https://plotly.com/javascript/reference/violin/) for full descriptions.

  - `:alignmentgroup` — string
  - `:bandwidth` — number, 0
  - `:box` — map (nested properties)
  - `:customdata` — data array
  - `:fillcolor` — color
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hoveron` — flags: "violins" | "points" | "kde" | "all"
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:jitter` — number, 0–1
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:marker` — map (nested properties)
  - `:meanline` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:offsetgroup` — string
  - `:opacity` — number, 0–1
  - `:orientation` — one of: "v" | "h"
  - `:pointpos` — number, -2–2
  - `:points` — one of: "all" | "outliers" | "suspectedoutliers" | false
  - `:quartilemethod` — one of: "linear" | "exclusive" | "inclusive"
  - `:scalegroup` — string
  - `:scalemode` — one of: "width" | "count"
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:side` — one of: "both" | "positive" | "negative"
  - `:span` — any
  - `:spanmode` — one of: "soft" | "hard" | "manual"
  - `:text` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  - `:width` — number, 0
  - `:x` — data array
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:xhoverformat` — string
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:yhoverformat` — string
  - `:zorder` — integer
  """

  defstruct [
    :alignmentgroup,
    :bandwidth,
    :box,
    :customdata,
    :fillcolor,
    :hoverinfo,
    :hoverlabel,
    :hoveron,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :jitter,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :marker,
    :meanline,
    :meta,
    :name,
    :offsetgroup,
    :opacity,
    :orientation,
    :pointpos,
    :points,
    :quartilemethod,
    :scalegroup,
    :scalemode,
    :selected,
    :selectedpoints,
    :showlegend,
    :side,
    :span,
    :spanmode,
    :text,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    :width,
    :x,
    :x0,
    :xaxis,
    :xhoverformat,
    :y,
    :y0,
    :yaxis,
    :yhoverformat,
    :zorder,
    type: "violin"
  ]

  @doc "Violin plot combining box plot with kernel density estimate. Construct a Violin trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Violin do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

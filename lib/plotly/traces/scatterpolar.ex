# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Scatterpolar do
  @moduledoc """
  Plotly Scatterpolar trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly scatterpolar reference](https://plotly.com/javascript/reference/scatterpolar/) for full descriptions.

  - `:cliponaxis` — boolean
  - `:connectgaps` — boolean
  - `:customdata` — data array
  - `:dr` — number
  - `:dtheta` — number
  - `:fill` — one of: "none" | "toself" | "tonext"
  - `:fillcolor` — color
  - `:hoverinfo` — flags: "r" | "theta" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hoveron` — flags: "points" | "fills"
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:mode` — flags: "lines" | "markers" | "text" | "none"
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:r` — data array
  - `:r0` — any
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:subplot` — string (subplot id)
  - `:text` — string
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:theta` — data array
  - `:theta0` — any
  - `:thetaunit` — one of: "radians" | "degrees" | "gradians"
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :cliponaxis,
    :connectgaps,
    :customdata,
    :dr,
    :dtheta,
    :fill,
    :fillcolor,
    :hoverinfo,
    :hoverlabel,
    :hoveron,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :marker,
    :meta,
    :mode,
    :name,
    :opacity,
    :r,
    :r0,
    :selected,
    :selectedpoints,
    :showlegend,
    :subplot,
    :text,
    :textfont,
    :textposition,
    :texttemplate,
    :texttemplatefallback,
    :theta,
    :theta0,
    :thetaunit,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    type: "scatterpolar"
  ]

  @doc "Construct a Scatterpolar trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Scatterpolar do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

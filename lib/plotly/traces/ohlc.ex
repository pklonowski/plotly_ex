# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Ohlc do
  @moduledoc """
  Plotly Ohlc trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly ohlc reference](https://plotly.com/javascript/reference/ohlc/) for full descriptions.

  - `:close` — data array
  - `:customdata` — data array
  - `:decreasing` — map (nested properties)
  - `:high` — data array
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:increasing` — map (nested properties)
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:low` — data array
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:open` — data array
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:text` — string
  - `:tickwidth` — number, 0–0.5
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xaxis` — string (subplot id)
  - `:xcalendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:xhoverformat` — string
  - `:xperiod` — any
  - `:xperiod0` — any
  - `:xperiodalignment` — one of: "start" | "middle" | "end"
  - `:yaxis` — string (subplot id)
  - `:yhoverformat` — string
  - `:zorder` — integer
  """

  defstruct [
    :close,
    :customdata,
    :decreasing,
    :high,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertext,
    :ids,
    :increasing,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :low,
    :meta,
    :name,
    :opacity,
    :open,
    :selectedpoints,
    :showlegend,
    :text,
    :tickwidth,
    :uid,
    :uirevision,
    :visible,
    :x,
    :xaxis,
    :xcalendar,
    :xhoverformat,
    :xperiod,
    :xperiod0,
    :xperiodalignment,
    :yaxis,
    :yhoverformat,
    :zorder,
    type: "ohlc"
  ]

  @doc "OHLC financial chart with tick marks. Construct a Ohlc trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Ohlc do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

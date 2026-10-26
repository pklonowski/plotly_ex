# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Indicator do
  @moduledoc """
  Plotly Indicator trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly indicator reference](https://plotly.com/javascript/reference/indicator/) for full descriptions.

  - `:align` — one of: "left" | "center" | "right"
  - `:customdata` — data array
  - `:delta` — map (nested properties)
  - `:domain` — map (nested properties)
  - `:gauge` — map (nested properties)
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:mode` — flags: "number" | "delta" | "gauge"
  - `:name` — string
  - `:number` — map (nested properties)
  - `:title` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:value` — number
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :align,
    :customdata,
    :delta,
    :domain,
    :gauge,
    :ids,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :mode,
    :name,
    :number,
    :title,
    :uid,
    :uirevision,
    :value,
    :visible,
    type: "indicator"
  ]

  @doc "Single-value KPI: number, gauge, or bullet. Construct a Indicator trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Indicator do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

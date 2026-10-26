# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Carpet do
  @moduledoc """
  Plotly Carpet trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly carpet reference](https://plotly.com/javascript/reference/carpet/) for full descriptions.

  - `:a` — data array
  - `:a0` — number
  - `:aaxis` — map (nested properties)
  - `:b` — data array
  - `:b0` — number
  - `:baxis` — map (nested properties)
  - `:carpet` — string
  - `:cheaterslope` — number
  - `:color` — color
  - `:customdata` — data array
  - `:da` — number
  - `:db` — number
  - `:font` — map (nested properties)
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xaxis` — string (subplot id)
  - `:y` — data array
  - `:yaxis` — string (subplot id)
  - `:zorder` — integer
  """

  defstruct [
    :a,
    :a0,
    :aaxis,
    :b,
    :b0,
    :baxis,
    :carpet,
    :cheaterslope,
    :color,
    :customdata,
    :da,
    :db,
    :font,
    :ids,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :name,
    :opacity,
    :uid,
    :uirevision,
    :visible,
    :x,
    :xaxis,
    :y,
    :yaxis,
    :zorder,
    type: "carpet"
  ]

  @doc "Construct a Carpet trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Carpet do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

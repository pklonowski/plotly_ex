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
  - `:asrc` — any
  - `:b` — data array
  - `:b0` — number
  - `:baxis` — map (nested properties)
  - `:bsrc` — any
  - `:carpet` — string
  - `:cheaterslope` — number
  - `:color` — color
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:da` — number
  - `:db` — number
  - `:font` — map (nested properties)
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:stream` — map (nested properties)
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:xaxis` — string (subplot id)
  - `:xsrc` — any
  - `:y` — data array
  - `:yaxis` — string (subplot id)
  - `:ysrc` — any
  - `:zorder` — integer
  """

  defstruct [
    :a,
    :a0,
    :aaxis,
    :asrc,
    :b,
    :b0,
    :baxis,
    :bsrc,
    :carpet,
    :cheaterslope,
    :color,
    :customdata,
    :customdatasrc,
    :da,
    :db,
    :font,
    :ids,
    :idssrc,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :stream,
    :uid,
    :uirevision,
    :visible,
    :x,
    :xaxis,
    :xsrc,
    :y,
    :yaxis,
    :ysrc,
    :zorder,
    type: "carpet"
  ]

  @doc "Construct a Carpet trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
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

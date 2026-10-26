# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Table do
  @moduledoc """
  Plotly Table trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly table reference](https://plotly.com/javascript/reference/table/) for full descriptions.

  - `:cells` — map (nested properties)
  - `:columnorder` — data array
  - `:columnwidth` — number
  - `:customdata` — data array
  - `:domain` — map (nested properties)
  - `:header` — map (nested properties)
  - `:hoverinfo` — flags: "x" | "y" | "z" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:meta` — any
  - `:name` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :cells,
    :columnorder,
    :columnwidth,
    :customdata,
    :domain,
    :header,
    :hoverinfo,
    :hoverlabel,
    :ids,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :meta,
    :name,
    :uid,
    :uirevision,
    :visible,
    type: "table"
  ]

  @doc "Construct a Table trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Table do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

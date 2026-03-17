# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Parcoords do
  @moduledoc """
  Plotly Parcoords trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly parcoords reference](https://plotly.com/javascript/reference/parcoords/) for full descriptions.

  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:dimensiondefaults` — map (nested properties)
  - `:dimensions` — list of maps (nested properties)
  - `:domain` — map (nested properties)
  - `:ids` — data array
  - `:idssrc` — any
  - `:labelangle` — number (angle in degrees)
  - `:labelfont` — map (nested properties)
  - `:labelside` — one of: "top" | "bottom"
  - `:legend` — string (subplot id)
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:rangefont` — map (nested properties)
  - `:stream` — map (nested properties)
  - `:tickfont` — map (nested properties)
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :customdata,
    :customdatasrc,
    :dimensiondefaults,
    :dimensions,
    :domain,
    :ids,
    :idssrc,
    :labelangle,
    :labelfont,
    :labelside,
    :legend,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :meta,
    :metasrc,
    :name,
    :rangefont,
    :stream,
    :tickfont,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    type: "parcoords"
  ]

  @doc "Parallel coordinates for multivariate data. Construct a Parcoords trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Parcoords do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

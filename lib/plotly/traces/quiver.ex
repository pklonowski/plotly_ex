# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Quiver do
  @moduledoc """
  Plotly Quiver trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly quiver reference](https://plotly.com/javascript/reference/quiver/) for full descriptions.

  - `:anchor` — one of: "tip" | "tail" | "center"
  - `:arrowref` — one of: "paper" | "data"
  - `:customdata` — data array
  - `:dx` — number
  - `:dy` — number
  - `:hoverinfo` — flags: "x" | "y" | "u" | "v" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:ids` — data array
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:lengthfactor` — number, 0
  - `:lengthmode` — one of: "scaled" | "raw"
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:text` — string
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:u` — data array
  - `:uhoverformat` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:v` — data array
  - `:vhoverformat` — string
  - `:visible` — one of: true | false | "legendonly"
  - `:x` — data array
  - `:x0` — any
  - `:xaxis` — string (subplot id)
  - `:xhoverformat` — string
  - `:y` — data array
  - `:y0` — any
  - `:yaxis` — string (subplot id)
  - `:yhoverformat` — string
  """

  defstruct [
    :anchor,
    :arrowref,
    :customdata,
    :dx,
    :dy,
    :hoverinfo,
    :hoverlabel,
    :hovertemplate,
    :ids,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :lengthfactor,
    :lengthmode,
    :marker,
    :meta,
    :name,
    :opacity,
    :selected,
    :selectedpoints,
    :showlegend,
    :text,
    :textfont,
    :textposition,
    :u,
    :uhoverformat,
    :uid,
    :uirevision,
    :unselected,
    :v,
    :vhoverformat,
    :visible,
    :x,
    :x0,
    :xaxis,
    :xhoverformat,
    :y,
    :y0,
    :yaxis,
    :yhoverformat,
    type: "quiver"
  ]

  @doc "Vector field arrows from x/y positions and u/v components. Construct a Quiver trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Quiver do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

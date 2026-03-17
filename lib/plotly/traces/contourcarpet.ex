# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Contourcarpet do
  @moduledoc """
  Plotly Contourcarpet trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly contourcarpet reference](https://plotly.com/javascript/reference/contourcarpet/) for full descriptions.

  - `:a` — data array
  - `:a0` — any
  - `:asrc` — any
  - `:atype` — one of: "array" | "scaled"
  - `:autocolorscale` — boolean
  - `:autocontour` — boolean
  - `:b` — data array
  - `:b0` — any
  - `:bsrc` — any
  - `:btype` — one of: "array" | "scaled"
  - `:carpet` — string
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:contours` — map (nested properties)
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:da` — number
  - `:db` — number
  - `:fillcolor` — color
  - `:hovertext` — data array
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:ncontours` — integer
  - `:opacity` — number, 0–1
  - `:reversescale` — boolean
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:stream` — map (nested properties)
  - `:text` — data array
  - `:textsrc` — any
  - `:transpose` — boolean
  - `:uid` — string
  - `:uirevision` — any
  - `:visible` — one of: true | false | "legendonly"
  - `:xaxis` — string (subplot id)
  - `:yaxis` — string (subplot id)
  - `:z` — data array
  - `:zauto` — boolean
  - `:zmax` — number
  - `:zmid` — number
  - `:zmin` — number
  - `:zorder` — integer
  - `:zsrc` — any
  """

  defstruct [
    :a,
    :a0,
    :asrc,
    :atype,
    :autocolorscale,
    :autocontour,
    :b,
    :b0,
    :bsrc,
    :btype,
    :carpet,
    :coloraxis,
    :colorbar,
    :colorscale,
    :contours,
    :customdata,
    :customdatasrc,
    :da,
    :db,
    :fillcolor,
    :hovertext,
    :hovertextsrc,
    :ids,
    :idssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :meta,
    :metasrc,
    :name,
    :ncontours,
    :opacity,
    :reversescale,
    :showlegend,
    :showscale,
    :stream,
    :text,
    :textsrc,
    :transpose,
    :uid,
    :uirevision,
    :visible,
    :xaxis,
    :yaxis,
    :z,
    :zauto,
    :zmax,
    :zmid,
    :zmin,
    :zorder,
    :zsrc,
    type: "contourcarpet"
  ]

  @doc "Construct a Contourcarpet trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Contourcarpet do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

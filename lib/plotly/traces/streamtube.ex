# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Streamtube do
  @moduledoc """
  Plotly Streamtube trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly streamtube reference](https://plotly.com/javascript/reference/streamtube/) for full descriptions.

  - `:autocolorscale` — boolean
  - `:cauto` — boolean
  - `:cmax` — number
  - `:cmid` — number
  - `:cmin` — number
  - `:coloraxis` — string (subplot id)
  - `:colorbar` — map (nested properties)
  - `:colorscale` — colorscale
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:hoverinfo` — flags: "x" | "y" | "z" | "u" | "v" | "w" | "norm" | "divergence" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:lighting` — map (nested properties)
  - `:lightposition` — map (nested properties)
  - `:maxdisplayed` — integer
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:reversescale` — boolean
  - `:scene` — string (subplot id)
  - `:showlegend` — boolean
  - `:showscale` — boolean
  - `:sizeref` — number, 0
  - `:starts` — map (nested properties)
  - `:stream` — map (nested properties)
  - `:text` — string
  - `:u` — data array
  - `:uhoverformat` — string
  - `:uid` — string
  - `:uirevision` — any
  - `:usrc` — any
  - `:v` — data array
  - `:vhoverformat` — string
  - `:visible` — one of: true | false | "legendonly"
  - `:vsrc` — any
  - `:w` — data array
  - `:whoverformat` — string
  - `:wsrc` — any
  - `:x` — data array
  - `:xhoverformat` — string
  - `:xsrc` — any
  - `:y` — data array
  - `:yhoverformat` — string
  - `:ysrc` — any
  - `:z` — data array
  - `:zhoverformat` — string
  - `:zsrc` — any
  """

  defstruct [
    :autocolorscale,
    :cauto,
    :cmax,
    :cmid,
    :cmin,
    :coloraxis,
    :colorbar,
    :colorscale,
    :customdata,
    :customdatasrc,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :hovertext,
    :ids,
    :idssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :lighting,
    :lightposition,
    :maxdisplayed,
    :meta,
    :metasrc,
    :name,
    :opacity,
    :reversescale,
    :scene,
    :showlegend,
    :showscale,
    :sizeref,
    :starts,
    :stream,
    :text,
    :u,
    :uhoverformat,
    :uid,
    :uirevision,
    :usrc,
    :v,
    :vhoverformat,
    :visible,
    :vsrc,
    :w,
    :whoverformat,
    :wsrc,
    :x,
    :xhoverformat,
    :xsrc,
    :y,
    :yhoverformat,
    :ysrc,
    :z,
    :zhoverformat,
    :zsrc,
    type: "streamtube"
  ]

  @doc "Construct a Streamtube trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Streamtube do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

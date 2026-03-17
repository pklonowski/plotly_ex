# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Barpolar do
  @moduledoc """
  Plotly Barpolar trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly barpolar reference](https://plotly.com/javascript/reference/barpolar/) for full descriptions.

  - `:base` — any
  - `:basesrc` — any
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:dr` — number
  - `:dtheta` — number
  - `:hoverinfo` — flags: "r" | "theta" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:name` — string
  - `:offset` — number
  - `:offsetsrc` — any
  - `:opacity` — number, 0–1
  - `:r` — data array
  - `:r0` — any
  - `:rsrc` — any
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:stream` — map (nested properties)
  - `:subplot` — string (subplot id)
  - `:text` — string
  - `:textsrc` — any
  - `:theta` — data array
  - `:theta0` — any
  - `:thetasrc` — any
  - `:thetaunit` — one of: "radians" | "degrees" | "gradians"
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  - `:width` — number, 0
  - `:widthsrc` — any
  """

  defstruct [
    :base,
    :basesrc,
    :customdata,
    :customdatasrc,
    :dr,
    :dtheta,
    :hoverinfo,
    :hoverinfosrc,
    :hoverlabel,
    :hovertemplate,
    :hovertemplatefallback,
    :hovertemplatesrc,
    :hovertext,
    :hovertextsrc,
    :ids,
    :idssrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :marker,
    :meta,
    :metasrc,
    :name,
    :offset,
    :offsetsrc,
    :opacity,
    :r,
    :r0,
    :rsrc,
    :selected,
    :selectedpoints,
    :showlegend,
    :stream,
    :subplot,
    :text,
    :textsrc,
    :theta,
    :theta0,
    :thetasrc,
    :thetaunit,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    :width,
    :widthsrc,
    type: "barpolar"
  ]

  @doc "Construct a Barpolar trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Barpolar do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

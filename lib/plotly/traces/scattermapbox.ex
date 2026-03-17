# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Scattermapbox do
  @moduledoc """
  Plotly Scattermapbox trace struct.
  All top-level trace properties are struct fields.
  Unknown keys raise ArgumentError at construction time.

  Nested properties (marker, line, etc.) accept plain maps or keyword lists —
  keyword lists are automatically normalised to maps before JSON encoding.


  ## Fields

  See the [Plotly scattermapbox reference](https://plotly.com/javascript/reference/scattermapbox/) for full descriptions.

  - `:below` — string
  - `:cluster` — map (nested properties)
  - `:connectgaps` — boolean
  - `:customdata` — data array
  - `:customdatasrc` — any
  - `:fill` — one of: "none" | "toself"
  - `:fillcolor` — color
  - `:hoverinfo` — flags: "lon" | "lat" | "text" | "name" | "all" | "none" | "skip"
  - `:hoverinfosrc` — any
  - `:hoverlabel` — map (nested properties)
  - `:hovertemplate` — string
  - `:hovertemplatefallback` — any
  - `:hovertemplatesrc` — any
  - `:hovertext` — string
  - `:hovertextsrc` — any
  - `:ids` — data array
  - `:idssrc` — any
  - `:lat` — data array
  - `:latsrc` — any
  - `:legend` — string (subplot id)
  - `:legendgroup` — string
  - `:legendgrouptitle` — map (nested properties)
  - `:legendrank` — number
  - `:legendwidth` — number, 0
  - `:line` — map (nested properties)
  - `:lon` — data array
  - `:lonsrc` — any
  - `:marker` — map (nested properties)
  - `:meta` — any
  - `:metasrc` — any
  - `:mode` — flags: "lines" | "markers" | "text" | "none"
  - `:name` — string
  - `:opacity` — number, 0–1
  - `:selected` — map (nested properties)
  - `:selectedpoints` — any
  - `:showlegend` — boolean
  - `:stream` — map (nested properties)
  - `:subplot` — string (subplot id)
  - `:text` — string
  - `:textfont` — map (nested properties)
  - `:textposition` — one of: "top left" | "top center" | "top right" | "middle left" | "middle center" | "middle right" | "bottom left" | "bottom center" | "bottom right"
  - `:textsrc` — any
  - `:texttemplate` — string
  - `:texttemplatefallback` — any
  - `:texttemplatesrc` — any
  - `:uid` — string
  - `:uirevision` — any
  - `:unselected` — map (nested properties)
  - `:visible` — one of: true | false | "legendonly"
  """

  defstruct [
    :below,
    :cluster,
    :connectgaps,
    :customdata,
    :customdatasrc,
    :fill,
    :fillcolor,
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
    :lat,
    :latsrc,
    :legend,
    :legendgroup,
    :legendgrouptitle,
    :legendrank,
    :legendwidth,
    :line,
    :lon,
    :lonsrc,
    :marker,
    :meta,
    :metasrc,
    :mode,
    :name,
    :opacity,
    :selected,
    :selectedpoints,
    :showlegend,
    :stream,
    :subplot,
    :text,
    :textfont,
    :textposition,
    :textsrc,
    :texttemplate,
    :texttemplatefallback,
    :texttemplatesrc,
    :uid,
    :uirevision,
    :unselected,
    :visible,
    type: "scattermapbox"
  ]

  @doc "Construct a Scattermapbox trace. Raises ArgumentError on unknown keys."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Scattermapbox do
  def encode(trace, opts) do
    trace
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Jason.Encode.map(opts)
  end
end

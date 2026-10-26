# THIS FILE IS AUTO-GENERATED — do not edit by hand.
# Re-run `mix plotly.gen` to regenerate.

defmodule Plotly.Layout do
  @moduledoc """
  Plotly Layout struct.
  Unknown keys raise ArgumentError at construction time.

  ## Commonly-used fields

  - `:title` — string or map with `:text`, `:font`, `:x`, `:y`
  - `:width`, `:height` — integer pixels (default: fills container)
  - `:xaxis`, `:yaxis` — map with `:title`, `:type`, `:range`, `:showgrid`
  - `:legend` — map with `:orientation`, `:x`, `:y`, `:bgcolor`
  - `:margin` — map with `:l`, `:r`, `:t`, `:b` pixel integers
  - `:showlegend` — boolean; auto-true when multiple traces present
  - `:template` — inline template map or bundled name (see `Plotly.Templates`)
  - `:barmode` — `"group"` | `"stack"` | `"overlay"` | `"relative"`


  ## Fields

  See the [Plotly layout reference](https://plotly.com/javascript/reference/layout/) for full descriptions.

  - `:activeselection` — map (nested properties)
  - `:activeshape` — map (nested properties)
  - `:annotationdefaults` — map (nested properties)
  - `:annotations` — list of maps (nested properties)
  - `:autosize` — boolean
  - `:autotypenumbers` — one of: "convert types" | "strict"
  - `:barcornerradius` — any
  - `:bargap` — number, 0–1
  - `:bargroupgap` — number, 0–1
  - `:barmode` — one of: "stack" | "group" | "overlay" | "relative"
  - `:barnorm` — one of: "" | "fraction" | "percent"
  - `:boxgap` — number, 0–1
  - `:boxgroupgap` — number, 0–1
  - `:boxmode` — one of: "group" | "overlay"
  - `:calendar` — one of: "chinese" | "coptic" | "discworld" | "ethiopian" | "gregorian" | "hebrew" | "islamic" | "jalali" | "julian" | "mayan" | "nanakshahi" | "nepali" | "persian" | "taiwan" | "thai" | "ummalqura"
  - `:clickanywhere` — boolean
  - `:clickmode` — flags: "event" | "select" | "none"
  - `:coloraxis` — map (nested properties)
  - `:colorscale` — map (nested properties)
  - `:colorway` — list of colors
  - `:computed` — any
  - `:datarevision` — any
  - `:dragmode` — one of: "zoom" | "pan" | "select" | "lasso" | "drawclosedpath" | "drawopenpath" | "drawline" | "drawrect" | "drawcircle" | "orbit" | "turntable" | false
  - `:editrevision` — any
  - `:extendfunnelareacolors` — boolean
  - `:extendiciclecolors` — boolean
  - `:extendpiecolors` — boolean
  - `:extendsunburstcolors` — boolean
  - `:extendtreemapcolors` — boolean
  - `:font` — map (nested properties)
  - `:funnelareacolorway` — list of colors
  - `:funnelgap` — number, 0–1
  - `:funnelgroupgap` — number, 0–1
  - `:funnelmode` — one of: "stack" | "group" | "overlay"
  - `:geo` — map (nested properties)
  - `:grid` — map (nested properties)
  - `:height` — number, 10
  - `:hiddenlabels` — data array
  - `:hoveranywhere` — boolean
  - `:hoverdistance` — integer
  - `:hoverlabel` — map (nested properties)
  - `:hovermode` — one of: "x" | "y" | "closest" | false | "x unified" | "y unified"
  - `:hoversort` — one of: "trace" | "value descending" | "value ascending"
  - `:hoversubplots` — one of: "single" | "overlaying" | "axis"
  - `:iciclecolorway` — list of colors
  - `:imagedefaults` — map (nested properties)
  - `:images` — list of maps (nested properties)
  - `:legend` — map (nested properties)
  - `:map` — map (nested properties)
  - `:margin` — map (nested properties)
  - `:meta` — any
  - `:minreducedheight` — number, 2
  - `:minreducedwidth` — number, 2
  - `:modebar` — map (nested properties)
  - `:newselection` — map (nested properties)
  - `:newshape` — map (nested properties)
  - `:paper_bgcolor` — color
  - `:piecolorway` — list of colors
  - `:plot_bgcolor` — color
  - `:polar` — map (nested properties)
  - `:scattergap` — number, 0–1
  - `:scattermode` — one of: "group" | "overlay"
  - `:scene` — map (nested properties)
  - `:selectdirection` — one of: "h" | "v" | "d" | "any"
  - `:selectiondefaults` — map (nested properties)
  - `:selectionrevision` — any
  - `:selections` — list of maps (nested properties)
  - `:separators` — string
  - `:shapedefaults` — map (nested properties)
  - `:shapes` — list of maps (nested properties)
  - `:showlegend` — boolean
  - `:sliderdefaults` — map (nested properties)
  - `:sliders` — list of maps (nested properties)
  - `:smith` — map (nested properties)
  - `:spikedistance` — integer
  - `:sunburstcolorway` — list of colors
  - `:template` — any
  - `:ternary` — map (nested properties)
  - `:title` — any
  - `:transition` — map (nested properties)
  - `:treemapcolorway` — list of colors
  - `:uirevision` — any
  - `:uniformtext` — map (nested properties)
  - `:updatemenudefaults` — map (nested properties)
  - `:updatemenus` — list of maps (nested properties)
  - `:violingap` — number, 0–1
  - `:violingroupgap` — number, 0–1
  - `:violinmode` — one of: "group" | "overlay"
  - `:waterfallgap` — number, 0–1
  - `:waterfallgroupgap` — number, 0–1
  - `:waterfallmode` — one of: "group" | "overlay"
  - `:width` — number, 10
  - `:xaxis` — map (nested properties)
  - `:yaxis` — map (nested properties)
  """

  defstruct [
    :activeselection,
    :activeshape,
    :annotationdefaults,
    :annotations,
    :autosize,
    :autotypenumbers,
    :barcornerradius,
    :bargap,
    :bargroupgap,
    :barmode,
    :barnorm,
    :boxgap,
    :boxgroupgap,
    :boxmode,
    :calendar,
    :clickanywhere,
    :clickmode,
    :coloraxis,
    :colorscale,
    :colorway,
    :computed,
    :datarevision,
    :dragmode,
    :editrevision,
    :extendfunnelareacolors,
    :extendiciclecolors,
    :extendpiecolors,
    :extendsunburstcolors,
    :extendtreemapcolors,
    :font,
    :funnelareacolorway,
    :funnelgap,
    :funnelgroupgap,
    :funnelmode,
    :geo,
    :grid,
    :height,
    :hiddenlabels,
    :hoveranywhere,
    :hoverdistance,
    :hoverlabel,
    :hovermode,
    :hoversort,
    :hoversubplots,
    :iciclecolorway,
    :imagedefaults,
    :images,
    :legend,
    :map,
    :margin,
    :meta,
    :minreducedheight,
    :minreducedwidth,
    :modebar,
    :newselection,
    :newshape,
    :paper_bgcolor,
    :piecolorway,
    :plot_bgcolor,
    :polar,
    :scattergap,
    :scattermode,
    :scene,
    :selectdirection,
    :selectiondefaults,
    :selectionrevision,
    :selections,
    :separators,
    :shapedefaults,
    :shapes,
    :showlegend,
    :sliderdefaults,
    :sliders,
    :smith,
    :spikedistance,
    :sunburstcolorway,
    :template,
    :ternary,
    :title,
    :transition,
    :treemapcolorway,
    :uirevision,
    :uniformtext,
    :updatemenudefaults,
    :updatemenus,
    :violingap,
    :violingroupgap,
    :violinmode,
    :waterfallgap,
    :waterfallgroupgap,
    :waterfallmode,
    :width,
    :xaxis,
    :yaxis
  ]

  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Enum.map(opts, &elem(&1, 0)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end
end

defimpl Jason.Encoder, for: Plotly.Layout do
  def encode(layout, opts) do
    layout
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
    |> Plotly.Normalize.deep_normalize()
    |> Plotly.Normalize.coerce_scene_axis_titles()
    |> Jason.Encode.map(opts)
  end
end

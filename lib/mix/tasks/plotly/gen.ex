defmodule Mix.Tasks.Plotly.Gen do
  @moduledoc """
  Generates Elixir struct files for all plotly.js trace types.

  Reads priv/schema/plotly_schema.json and writes one .ex file per trace
  into lib/plotly/traces/, plus lib/plotly/layout.ex.

  Usage:
      mix plotly.gen
  """

  use Mix.Task

  @schema_path "priv/schema/plotly_schema.json"
  @traces_dir "lib/plotly/traces"
  @layout_path "lib/plotly/layout.ex"

  @shortdoc "Generate Elixir structs from the plotly.js JSON schema"

  @trace_descriptions %{
    "scatter" => "X/Y scatter or line chart; mode controls markers vs lines.",
    "bar" => "Vertical or horizontal bar chart.",
    "histogram" => "Distribution of a numeric variable, auto-binned.",
    "box" => "Box-and-whisker plot: median, quartiles, outliers.",
    "violin" => "Violin plot combining box plot with kernel density estimate.",
    "pie" => "Circular proportional chart.",
    "heatmap" => "Z-values encoded as colour on a 2D grid.",
    "scatter3d" => "3D scatter chart using x, y, z axes.",
    "surface" => "3D surface plot from a z-matrix.",
    "choropleth" => "Choropleth map: regions coloured by value.",
    "scattergeo" => "Scatter points on a geo projection map.",
    "scattermap" => "Scatter points on a tile map (requires lat/lon).",
    "candlestick" => "OHLC financial chart with filled candles.",
    "ohlc" => "OHLC financial chart with tick marks.",
    "waterfall" => "Cumulative chart showing incremental +/- values.",
    "funnel" => "Funnel chart for sequential stage values.",
    "sunburst" => "Multi-level radial hierarchy chart.",
    "treemap" => "Rectangular hierarchy chart (nested rectangles).",
    "indicator" => "Single-value KPI: number, gauge, or bullet.",
    "histogram2d" => "2D binned density heatmap.",
    "splom" => "Scatter plot matrix — all pairwise dimension combinations.",
    "parcoords" => "Parallel coordinates for multivariate data.",
    "sankey" => "Flow diagram: quantities between source/target nodes."
  }

  @impl Mix.Task
  def run(_args) do
    schema = @schema_path |> File.read!() |> Jason.decode!()

    File.mkdir_p!(@traces_dir)

    # Generate trace modules
    for name <- trace_names(schema) do
      path = Path.join(@traces_dir, "#{name}.ex")
      content = generate_trace_module(schema, name)
      File.write!(path, content)
      Mix.shell().info("Generated #{path}")
    end

    # Generate layout module
    File.write!(@layout_path, generate_layout_module(schema))
    Mix.shell().info("Generated #{@layout_path}")
  end

  @doc "Return all trace type names found in the schema (excludes layout)."
  def trace_names(schema) do
    schema
    |> Map.keys()
    |> Enum.flat_map(fn key ->
      case String.split(key, ".", parts: 2) do
        [parent, _child] -> [parent]
        _ -> []
      end
    end)
    |> Enum.uniq()
    |> Enum.reject(&(&1 in ["layout", "frames"]))
    |> Enum.sort()
  end

  @doc "Return the list of top-level field name atoms for a given trace type."
  def trace_fields(schema, trace_name) do
    schema
    |> Map.keys()
    |> Enum.filter(fn key ->
      # Match "scatter.x" but not "scatter.marker.color"
      case String.split(key, ".") do
        [^trace_name, _prop] -> true
        _ -> false
      end
    end)
    |> Enum.map(fn key ->
      [_trace, prop] = String.split(key, ".", parts: 2)
      String.to_atom(prop)
    end)
    |> Enum.sort()
  end

  @doc "Return a map of field atom => schema entry for top-level fields of a trace/layout."
  def trace_field_metadata(schema, trace_name) do
    schema
    |> Enum.filter(fn {key, _} ->
      case String.split(key, ".") do
        [^trace_name, _prop] -> true
        _ -> false
      end
    end)
    |> Map.new(fn {key, entry} ->
      [_trace, prop] = String.split(key, ".", parts: 2)
      {String.to_atom(prop), entry}
    end)
  end

  @doc "Return a short human-readable type hint string for a schema entry."
  def field_type_hint(%{"superclass" => superclass, "params" => params}) do
    case superclass do
      "DataArrayValidator" ->
        "data array"

      "BooleanValidator" ->
        "boolean"

      "NumberValidator" ->
        min = Map.get(params, "min")
        max = Map.get(params, "max")

        if min != nil || max != nil do
          range =
            [min && to_string(min), max && to_string(max)]
            |> Enum.reject(&is_nil/1)
            |> Enum.join("–")

          "number, #{range}"
        else
          "number"
        end

      "IntegerValidator" ->
        "integer"

      "StringValidator" ->
        "string"

      "ColorValidator" ->
        "color"

      "ColorlistValidator" ->
        "list of colors"

      "ColorscaleValidator" ->
        "colorscale"

      "EnumeratedValidator" ->
        values = Map.get(params, "values", [])
        formatted = values |> Enum.map(&inspect/1) |> Enum.join(" | ")
        "one of: #{formatted}"

      "FlaglistValidator" ->
        flags = Map.get(params, "flags", [])
        extras = Map.get(params, "extras", [])
        all = flags ++ extras
        formatted = all |> Enum.map(&inspect/1) |> Enum.join(" | ")
        "flags: #{formatted}"

      "CompoundValidator" ->
        "map (nested properties)"

      "CompoundArrayValidator" ->
        "list of maps (nested properties)"

      "AngleValidator" ->
        "number (angle in degrees)"

      "SubplotidValidator" ->
        "string (subplot id)"

      _ ->
        "any"
    end
  end

  def field_type_hint(_), do: "any"

  @doc "Build the ## Fields markdown section for a trace or layout module."
  def field_docs_section(schema, trace_name, ref_url) do
    metadata = trace_field_metadata(schema, trace_name)

    field_lines =
      metadata
      |> Map.delete(:type)
      |> Enum.sort_by(fn {k, _} -> k end)
      |> Enum.map(fn {field, entry} ->
        hint = field_type_hint(entry)
        "  - `#{inspect(field)}` — #{hint}"
      end)
      |> Enum.join("\n")

    # Each line carries its own 2-space prefix so it satisfies the @moduledoc
    # heredoc indentation requirement (closing """ is at 2-space indent).
    "\n\n  ## Fields\n\n  See the [Plotly #{trace_name} reference](#{ref_url})" <>
      " for full descriptions.\n\n" <> field_lines <> "\n"
  end

  @doc "Generate the full Elixir module source for a trace type."
  def generate_trace_module(schema, trace_name) do
    module_name = Macro.camelize(trace_name)
    description = Map.get(@trace_descriptions, trace_name, "")
    fields = trace_fields(schema, trace_name)

    # Render field list: fields with defaults last (type has a default)
    fields_without_type = fields |> Enum.reject(&(&1 == :type))

    fields_str =
      (Enum.map(fields_without_type, &inspect/1) ++
         [~s[type: "#{trace_name}"]])
      |> Enum.join(",\n    ")

    ref_url = "https://plotly.com/javascript/reference/#{trace_name}/"
    fields_section = field_docs_section(schema, trace_name, ref_url)

    """
    # THIS FILE IS AUTO-GENERATED — do not edit by hand.
    # Re-run `mix plotly.gen` to regenerate.

    defmodule Plotly.#{module_name} do
      @moduledoc \"\"\"
      Plotly #{module_name} trace struct.
      All top-level trace properties are struct fields.
      Unknown keys raise ArgumentError at construction time.

      Nested properties (marker, line, etc.) accept plain maps or keyword lists —
      keyword lists are automatically normalised to maps before JSON encoding.
    #{String.trim_trailing(fields_section)}
      \"\"\"

      defstruct [
        #{fields_str}
      ]

      @doc \"#{if description != "", do: description <> " ", else: ""}Construct a #{module_name} trace. Raises ArgumentError on unknown keys.\"
      def new(opts \\\\ []) do
        struct!(__MODULE__, opts)
      rescue
        KeyError ->
          valid = Map.keys(%__MODULE__{}) -- [:__struct__]
          bad = Keyword.keys(List.wrap(opts)) -- valid
          raise ArgumentError, "unknown keys \#{inspect(bad)} for struct \#{inspect(__MODULE__)}"
      end
    end

    defimpl Jason.Encoder, for: Plotly.#{module_name} do
      def encode(trace, opts) do
        trace
        |> Map.from_struct()
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()
        |> Plotly.Normalize.deep_normalize()
        |> Jason.Encode.map(opts)
      end
    end
    """
  end

  defp generate_layout_module(schema) do
    fields = trace_fields(schema, "layout")
    fields_str = fields |> Enum.map(&inspect/1) |> Enum.join(",\n    ")

    all_fields_section =
      field_docs_section(schema, "layout", "https://plotly.com/javascript/reference/layout/")

    """
    # THIS FILE IS AUTO-GENERATED — do not edit by hand.
    # Re-run `mix plotly.gen` to regenerate.

    defmodule Plotly.Layout do
      @moduledoc \"\"\"
      Plotly Layout struct.
      Unknown keys raise ArgumentError at construction time.

      ## Commonly-used fields

      - `:title` — string or map with `:text`, `:font`, `:x`, `:y`
      - `:width`, `:height` — integer pixels (default: fills container)
      - `:xaxis`, `:yaxis` — map with `:title`, `:type`, `:range`, `:showgrid`
      - `:legend` — map with `:orientation`, `:x`, `:y`, `:bgcolor`
      - `:margin` — map with `:l`, `:r`, `:t`, `:b` pixel integers
      - `:showlegend` — boolean; auto-true when multiple traces present
      - `:template` — Plotly.js template name (`"plotly_dark"`, `"ggplot2"`, etc.)
      - `:barmode` — `"group"` | `"stack"` | `"overlay"` | `"relative"`
      #{String.trim_trailing(all_fields_section)}
      \"\"\"

      defstruct [
        #{fields_str}
      ]

      def new(opts \\\\ []) do
        struct!(__MODULE__, opts)
      rescue
        KeyError ->
          valid = Map.keys(%__MODULE__{}) -- [:__struct__]
          bad = Keyword.keys(List.wrap(opts)) -- valid
          raise ArgumentError, "unknown keys \#{inspect(bad)} for struct \#{inspect(__MODULE__)}"
      end
    end

    defimpl Jason.Encoder, for: Plotly.Layout do
      def encode(layout, opts) do
        layout
        |> Map.from_struct()
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()
        |> Plotly.Normalize.deep_normalize()
        |> Jason.Encode.map(opts)
      end
    end
    """
  end
end

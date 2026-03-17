if Code.ensure_loaded?(Kino.JS) do
  defmodule Plotly.Kino.SmartCell do
    @moduledoc """
      No-code Plotly chart builder for Livebook.
      Auto-discovers notebook variables and populates X/Y/Color column dropdowns without typing column names.

    ## Supported chart types

    `scatter`, `bar`, `line`, `histogram`, `box`, `violin`, `pie`

    ## Multi-layer support

    Click **+ Add layer** to overlay additional traces on the same figure.
    Each layer is an independent `Plotly.Express` call; layers are combined via
    `Plotly.Figure.merge/2`, e.g.:

        Plotly.scatter(df, x: "date", y: "value")
        |> Plotly.Figure.merge(Plotly.bar(df2, x: "date", y: "count"))
        |> Plotly.show()

    ## Data sources

    - `Explorer.DataFrame` — column names and types are inferred automatically
    - List of string-keyed maps — e.g. `[%{"x" => 1, "y" => 2}]`
    - Columnar maps — e.g. `%{"x" => [1, 2], "y" => [3, 4]}`

    ## Generated code pattern

        Plotly.scatter(data, x: "col_a", y: "col_b") |> Plotly.show()
    """

    use Kino.JS
    use Kino.JS.Live
    use Kino.SmartCell, name: "Plotly Chart"

    @valid_chart_types ~w[scatter bar line histogram box violin pie]

    @default_layer %{
      "chart_type" => "scatter",
      "data_variable" => "",
      "x_field" => "",
      "y_field" => "",
      "color_field" => ""
    }

    # ── SmartCell callbacks ─────────────────────────────────────────────────

    @impl true
    def init(attrs, ctx) do
      {layers, global} = migrate_attrs(attrs)

      {:ok, assign(ctx, layers: layers, global: global, data_options: []),
       reevaluate_on_change: true}
    end

    # Detect format and normalise to {layers, global}.
    defp migrate_attrs(%{"layers" => layers} = attrs) when is_list(layers) do
      global = %{
        "title" => attrs["title"] || "",
        "width" => attrs["width"] || "",
        "height" => attrs["height"] || ""
      }

      layers = Enum.map(layers, &ensure_layer_defaults/1)
      {layers, global}
    end

    defp migrate_attrs(attrs) when map_size(attrs) == 0 do
      layer = Map.put(@default_layer, "id", "1")
      {[layer], %{"title" => "", "width" => "", "height" => ""}}
    end

    defp migrate_attrs(attrs) do
      # Old flat format — either new field names or very old names
      layer =
        @default_layer
        |> Map.put("id", "1")
        |> Map.put("chart_type", attrs["chart_type"] || "scatter")
        |> Map.put("data_variable", attrs["data_variable"] || attrs["variable"] || "")
        |> Map.put("x_field", attrs["x_field"] || attrs["x"] || "")
        |> Map.put("y_field", attrs["y_field"] || attrs["y"] || "")
        |> Map.put("color_field", attrs["color_field"] || attrs["color"] || "")

      global = %{
        "title" => attrs["title"] || "",
        "width" => attrs["width"] || "",
        "height" => attrs["height"] || ""
      }

      {[layer], global}
    end

    defp ensure_layer_defaults(layer) do
      Map.merge(@default_layer, layer)
    end

    @impl true
    def handle_connect(ctx) do
      payload = %{
        layers: ctx.assigns.layers,
        global: ctx.assigns.global,
        data_options: ctx.assigns.data_options
      }

      {:ok, payload, ctx}
    end

    @impl true
    def handle_event("add_layer", _payload, ctx) do
      new_layer =
        Map.put(@default_layer, "id", "#{System.unique_integer([:positive])}")

      layers = ctx.assigns.layers ++ [new_layer]
      broadcast_event(ctx, "layers_updated", layers)
      {:noreply, assign(ctx, layers: layers)}
    end

    @impl true
    def handle_event("remove_layer", %{"id" => id}, ctx) do
      layers = ctx.assigns.layers

      if length(layers) <= 1 do
        {:noreply, ctx}
      else
        layers = Enum.reject(layers, &(&1["id"] == id))
        broadcast_event(ctx, "layers_updated", layers)
        {:noreply, assign(ctx, layers: layers)}
      end
    end

    @impl true
    def handle_event("update_layer", %{"id" => id, "field" => field, "value" => value}, ctx) do
      layers =
        Enum.map(ctx.assigns.layers, fn layer ->
          if layer["id"] == id, do: Map.put(layer, field, value), else: layer
        end)

      broadcast_event(ctx, "layers_updated", layers)
      {:noreply, assign(ctx, layers: layers)}
    end

    @impl true
    def handle_event("update_global", %{"field" => field, "value" => value}, ctx) do
      global = Map.put(ctx.assigns.global, field, value)
      broadcast_event(ctx, "global_updated", global)
      {:noreply, assign(ctx, global: global)}
    end

    @impl true
    def handle_info({:scan_binding_result, data_options}, ctx) do
      broadcast_event(ctx, "data_options", data_options)
      {:noreply, assign(ctx, data_options: data_options)}
    end

    @impl true
    def to_attrs(ctx) do
      Map.merge(ctx.assigns.global, %{"layers" => ctx.assigns.layers})
    end

    @impl true
    def to_source(%{"layers" => layers} = attrs) do
      global = Map.take(attrs, ["title", "width", "height"])
      valid = Enum.filter(layers, &valid_layer?/1)

      case valid do
        [] ->
          "# Select a variable and chart type"

        [layer] ->
          single_source(layer, global)

        [first | rest] ->
          merges =
            Enum.map_join(rest, "\n", fn layer ->
              "|> Plotly.Figure.merge(#{express_call(layer, %{})})"
            end)

          "#{express_call(first, global)}\n#{merges}\n|> Plotly.show()"
      end
    end

    defp valid_layer?(%{"data_variable" => var, "chart_type" => chart}) do
      validate_identifier(var) == :ok and validate_chart_type(chart) == :ok
    end

    defp valid_layer?(_), do: false

    defp single_source(layer, global) do
      call = express_call(layer, global)
      "#{call} |> Plotly.show()"
    end

    defp express_call(%{"chart_type" => chart, "data_variable" => var} = layer, global) do
      opts =
        [
          x_opt(layer),
          y_opt(layer),
          color_opt(layer),
          title_opt(global),
          width_opt(global),
          height_opt(global)
        ]
        |> Enum.reject(&is_nil/1)
        |> Enum.join(", ")

      if opts == "" do
        "Plotly.#{chart}(#{var})"
      else
        "Plotly.#{chart}(#{var}, #{opts})"
      end
    end

    # ── scan_binding/3 — auto-discover tabular variables ───────────────────

    @impl true
    def scan_binding(pid, binding, _env) do
      data_options =
        for {key, val} <- binding,
            is_atom(key),
            columns = columns_for(val),
            do: %{variable: Atom.to_string(key), columns: columns}

      send(pid, {:scan_binding_result, data_options})
    end

    @doc false
    # Public for testing. Returns list of %{name, type} maps or nil.
    def columns_for(data) do
      cond do
        # Explorer.DataFrame (checked via struct name to avoid hard dep)
        is_struct(data) and explorer_dataframe?(data) ->
          extract_explorer_columns(data)

        # List of string-keyed maps
        is_list(data) and data != [] and is_map(hd(data)) ->
          keys = hd(data) |> Map.keys() |> Enum.filter(&is_binary/1) |> Enum.sort()
          if keys == [], do: nil, else: Enum.map(keys, &%{name: &1, type: "any"})

        # Columnar map: %{"col" => [v1, v2, ...], ...}
        is_map(data) and not is_struct(data) and map_size(data) > 0 ->
          keys = Map.keys(data) |> Enum.filter(&is_binary/1)
          vals = Map.values(data)

          if keys != [] and Enum.all?(vals, &is_list/1) do
            Enum.map(Enum.sort(keys), &%{name: &1, type: "any"})
          end

        true ->
          nil
      end
    end

    # ── Private helpers ──────────────────────────────────────────────────────

    defp explorer_dataframe?(data) do
      data.__struct__
      |> Module.split()
      |> List.last()
      |> Kernel.==("DataFrame")
    rescue
      _ -> false
    end

    defp extract_explorer_columns(df) do
      if Code.ensure_loaded?(Explorer.DataFrame) do
        apply(Explorer.DataFrame, :dtypes, [df])
        |> Enum.map(fn {k, v} -> %{name: k, type: inspect(v)} end)
        |> Enum.sort_by(& &1.name)
      end
    rescue
      _ -> nil
    end

    defp x_opt(%{"x_field" => ""}), do: nil
    defp x_opt(%{"x_field" => x}), do: ~s[x: "#{escape_string(x)}"]

    defp y_opt(%{"y_field" => ""}), do: nil
    defp y_opt(%{"y_field" => y}), do: ~s[y: "#{escape_string(y)}"]

    defp color_opt(%{"color_field" => ""}), do: nil
    defp color_opt(%{"color_field" => c}), do: ~s[color: "#{escape_string(c)}"]

    defp title_opt(%{"title" => ""}), do: nil
    defp title_opt(%{"title" => t}), do: ~s[title: "#{escape_string(t)}"]
    defp title_opt(_), do: nil

    defp width_opt(%{"width" => w}) when is_binary(w) and w != "" do
      case Integer.parse(w) do
        {n, ""} when n > 0 -> "width: #{n}"
        _ -> nil
      end
    end

    defp width_opt(_), do: nil

    defp height_opt(%{"height" => h}) when is_binary(h) and h != "" do
      case Integer.parse(h) do
        {n, ""} when n > 0 -> "height: #{n}"
        _ -> nil
      end
    end

    defp height_opt(_), do: nil

    defp validate_chart_type(t) when t in @valid_chart_types, do: :ok
    defp validate_chart_type(t), do: {:error, "unknown chart type: #{inspect(t)}"}

    defp validate_identifier(""), do: {:error, "variable name is empty"}

    defp validate_identifier(v) do
      if Regex.match?(~r/^[a-z_][a-zA-Z0-9_]*$/, v),
        do: :ok,
        else: {:error, "invalid Elixir identifier: #{inspect(v)}"}
    end

    defp escape_string(s), do: String.replace(s, "\"", "\\\"")

    asset "main.css" do
      """
      .plotly-cell {
        --plotly-navy:       #1f2c56;
        --plotly-blue:       #119DFF;
        --plotly-blue-alpha: rgba(17, 157, 255, 0.25);
        --gray-50:  #f8fafc;
        --gray-100: #f0f5f9;
        --gray-200: #e1e8f0;
        --gray-300: #cad5e0;
        --gray-400: #91a4b7;
        --gray-500: #61758a;
        --gray-600: #445668;
        --gray-700: #304254;
        --gray-800: #1c2a3a;
        --gray-900: #0d1829;

        font-family: "Inter", system-ui, sans-serif;
        box-sizing: border-box;
      }

      .plotly-cell *, .plotly-cell *::before, .plotly-cell *::after {
        box-sizing: inherit;
      }

      .plotly-cell p, .plotly-cell pre { margin: 0; }

      .pc-container {
        border: 1px solid var(--gray-300);
        border-radius: 0.5rem;
        background-color: rgba(248, 250, 252, 0.3);
        padding-bottom: 12px;
        overflow: hidden;
      }

      .pc-header {
        display: flex;
        align-items: center;
        background-color: var(--plotly-navy);
        padding: 8px 16px;
        margin-bottom: 4px;
        border-radius: 0.5rem 0.5rem 0 0;
        border-bottom: 1px solid rgba(255,255,255,0.08);
      }

      .pc-header-title {
        font-size: 0.75rem;
        font-weight: 600;
        color: rgba(255,255,255,0.85);
        text-transform: uppercase;
        letter-spacing: 0.06em;
        white-space: nowrap;
      }

      .pc-header-fields {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-left: 16px;
        flex: 1;
      }

      .pc-header-field {
        display: flex;
        align-items: center;
        gap: 5px;
      }

      .pc-header-label {
        font-size: 0.65rem;
        font-weight: 600;
        color: rgba(255,255,255,0.55);
        text-transform: uppercase;
        letter-spacing: 0.05em;
        white-space: nowrap;
      }

      .pc-header-input {
        appearance: none;
        padding: 4px 8px;
        background-color: rgba(255,255,255,0.1);
        font-size: 0.8rem;
        border: 1px solid rgba(255,255,255,0.2);
        border-radius: 0.3rem;
        color: rgba(255,255,255,0.9);
        font-family: inherit;
      }

      .pc-header-input--title { width: 180px; }
      .pc-header-input--dim   { width: 68px; }

      .pc-header-input::placeholder { color: rgba(255,255,255,0.3); }

      .pc-header-input:focus {
        outline: none;
        border-color: var(--plotly-blue);
        box-shadow: 0 0 0 2px var(--plotly-blue-alpha);
      }

      /* hide number spinner arrows */
      .pc-header-input[type="number"]::-webkit-inner-spin-button,
      .pc-header-input[type="number"]::-webkit-outer-spin-button { -webkit-appearance: none; }
      .pc-header-input[type="number"] { -moz-appearance: textfield; }

      .pc-row {
        display: flex;
        gap: 16px;
        flex-wrap: wrap;
        align-items: flex-end;
        margin: 8px 16px 0;
      }

      .pc-field {
        display: flex;
        flex-direction: column;
        gap: 3px;
        flex-basis: 160px;
        flex-grow: 1;
        max-width: 280px;
      }

      .pc-field--wide {
        flex-basis: 240px;
        max-width: 420px;
      }

      .pc-label {
        display: block;
        font-size: 0.7rem;
        font-weight: 600;
        color: var(--gray-500);
        text-transform: uppercase;
        letter-spacing: 0.05em;
      }

      .pc-input {
        appearance: none;
        padding: 7px 10px;
        background-color: var(--gray-50);
        font-size: 0.875rem;
        border: 1px solid var(--gray-200);
        border-radius: 0.4rem;
        color: var(--gray-700);
        width: 100%;
        font-family: inherit;
      }

      .pc-input::placeholder {
        color: var(--gray-400);
      }

      .pc-input:focus {
        outline: none;
        border-color: var(--plotly-blue);
        box-shadow: 0 0 0 3px var(--plotly-blue-alpha);
      }

      .pc-input:disabled {
        opacity: 0.5;
        cursor: not-allowed;
      }

      select.pc-input {
        background-image: url("data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iOCIgdmlld0JveD0iMCAwIDEyIDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZD0iTTUuOTk5ODkgNC45NzY3MUwxMC4xMjQ5IDAuODUxNzA4TDExLjMwMzIgMi4wMzAwNEw1Ljk5OTg5IDcuMzMzMzdMMC42OTY1NTUgMi4wMzAwNEwxLjg3NDg5IDAuODUxNzA4TDUuOTk5ODkgNC45NzY3MVoiIGZpbGw9IiM2MTc1OEEiLz48L3N2Zz4=");
        background-repeat: no-repeat;
        background-position: center right 10px;
        background-size: 10px;
        padding-right: 28px;
        cursor: pointer;
      }

      .hidden { display: none; }

      .pc-add-row {
        margin: 10px 16px 4px;
      }

      .pc-btn-add {
        appearance: none;
        background: transparent;
        border: 1px dashed var(--gray-400);
        border-radius: 0.4rem;
        color: var(--gray-500);
        cursor: pointer;
        font-size: 0.8rem;
        font-family: inherit;
        padding: 5px 14px;
        transition: border-color 0.15s, color 0.15s;
      }

      .pc-btn-add:hover {
        border-color: var(--plotly-blue);
        color: var(--plotly-blue);
      }

      .pc-layer {
        margin: 8px 16px 0;
        border: 1px solid var(--gray-200);
        border-left: 3px solid var(--plotly-blue);
        border-radius: 0.4rem;
        background: white;
      }

      .pc-layer-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 6px 10px;
        border-bottom: 1px solid var(--gray-100);
      }

      .pc-layer-title {
        font-size: 0.75rem;
        font-weight: 600;
        color: var(--gray-600);
        text-transform: uppercase;
        letter-spacing: 0.04em;
      }

      .pc-btn-remove {
        appearance: none;
        background: transparent;
        border: none;
        color: var(--gray-400);
        cursor: pointer;
        font-size: 0.75rem;
        padding: 2px 4px;
        line-height: 1;
        border-radius: 3px;
        transition: color 0.15s, background 0.15s;
      }

      .pc-btn-remove:hover {
        color: var(--gray-700);
        background: var(--gray-100);
      }

      .pc-layer-body {
        padding: 4px 0 8px;
      }
      """
    end

    asset "main.js" do
      """
      export function init(ctx, payload) {
        ctx.importCSS("main.css");

        const CHART_TYPES = ["scatter", "bar", "line", "histogram", "box", "violin", "pie"];

        let currentLayers = payload.layers || [];
        let currentGlobal = payload.global || {};
        let currentDataOptions = payload.data_options || [];

        // ── Build root HTML ──────────────────────────────────────────────────────
        ctx.root.innerHTML = `
          <div class="plotly-cell">
            <div class="pc-container">
              <div class="pc-header">
                <span class="pc-header-title">Plotly Chart</span>
                <div class="pc-header-fields">
                  <div class="pc-header-field">
                    <span class="pc-header-label">Title</span>
                    <input id="global-title" type="text" class="pc-header-input pc-header-input--title"
                      placeholder="Chart title..." value="${escHtml(currentGlobal.title || "")}" />
                  </div>
                  <div class="pc-header-field">
                    <span class="pc-header-label">W</span>
                    <input id="global-width" type="number" class="pc-header-input pc-header-input--dim"
                      placeholder="auto" min="100" step="50" value="${escHtml(currentGlobal.width || "")}" />
                  </div>
                  <div class="pc-header-field">
                    <span class="pc-header-label">H</span>
                    <input id="global-height" type="number" class="pc-header-input pc-header-input--dim"
                      placeholder="auto" min="100" step="50" value="${escHtml(currentGlobal.height || "")}" />
                  </div>
                </div>
              </div>
              <div id="layers-container"></div>
              <div class="pc-add-row">
                <button id="btn-add-layer" class="pc-btn-add">+ Add layer</button>
              </div>
            </div>
          </div>
        `;

        // ── Layer card template ──────────────────────────────────────────────────
        function layerHtml(layer, index, total) {
          const cols = columnsForVar(layer.data_variable);
          const showRemove = total > 1;

          return `
            <div class="pc-layer" data-layer-id="${layer.id}">
              <div class="pc-layer-header">
                <span class="pc-layer-title">Layer ${index + 1}</span>
                <button class="pc-btn-remove${showRemove ? "" : " hidden"}"
                  data-action="remove" data-id="${layer.id}" title="Remove layer">✕</button>
              </div>
              <div class="pc-layer-body">
                <div class="pc-row">
                  <label class="pc-field pc-field--wide">
                    <span class="pc-label">Variable</span>
                    <select class="pc-input" data-action="update_layer"
                      data-id="${layer.id}" data-field="data_variable">
                      <option value="">-- select variable --</option>
                      ${currentDataOptions.map(o =>
                        `<option value="${o.variable}"${o.variable === layer.data_variable ? " selected" : ""}>${o.variable}</option>`
                      ).join("")}
                    </select>
                  </label>
                  <label class="pc-field">
                    <span class="pc-label">Chart type</span>
                    <select class="pc-input" data-action="update_layer"
                      data-id="${layer.id}" data-field="chart_type">
                      ${CHART_TYPES.map(t =>
                        `<option value="${t}"${t === layer.chart_type ? " selected" : ""}>${t}</option>`
                      ).join("")}
                    </select>
                  </label>
                </div>
                <div class="pc-row">
                  ${columnSelect(layer, "x_field", "X axis", cols)}
                  ${columnSelect(layer, "y_field", "Y axis", cols)}
                  ${columnSelect(layer, "color_field", "Color by", cols)}
                </div>
              </div>
            </div>
          `;
        }

        function columnSelect(layer, field, label, cols) {
          return `
            <label class="pc-field">
              <span class="pc-label">${label}</span>
              <select class="pc-input" data-action="update_layer"
                data-id="${layer.id}" data-field="${field}">
                <option value="">-- none --</option>
                ${cols.map(c =>
                  `<option value="${c.name}"${c.name === layer[field] ? " selected" : ""}>${c.name}</option>`
                ).join("")}
              </select>
            </label>
          `;
        }

        function columnsForVar(varName) {
          const opt = currentDataOptions.find(o => o.variable === varName);
          return opt ? opt.columns : [];
        }

        function escHtml(s) {
          return s.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;");
        }

        // ── Render all layer cards ───────────────────────────────────────────────
        function renderLayers(layers) {
          const container = ctx.root.querySelector("#layers-container");
          container.innerHTML = layers.map((l, i) => layerHtml(l, i, layers.length)).join("");
        }

        renderLayers(currentLayers);

        // ── Event delegation ─────────────────────────────────────────────────────
        ctx.root.addEventListener("change", e => {
          const el = e.target;
          const action = el.dataset.action;
          if (action === "update_layer") {
            ctx.pushEvent("update_layer", {
              id: el.dataset.id,
              field: el.dataset.field,
              value: el.value
            });
            // If variable changed, re-render this layer's column dropdowns immediately
            if (el.dataset.field === "data_variable") {
              currentLayers = currentLayers.map(l =>
                l.id === el.dataset.id ? { ...l, data_variable: el.value } : l
              );
              renderLayers(currentLayers);
            }
          }
        });

        ctx.root.addEventListener("input", e => {
          const el = e.target;
          if (el.id === "global-title") {
            ctx.pushEvent("update_global", { field: "title", value: el.value });
          } else if (el.id === "global-width") {
            ctx.pushEvent("update_global", { field: "width", value: el.value });
          } else if (el.id === "global-height") {
            ctx.pushEvent("update_global", { field: "height", value: el.value });
          }
        });

        ctx.root.addEventListener("click", e => {
          const el = e.target.closest("[data-action]");
          if (!el) return;
          if (el.dataset.action === "remove") {
            ctx.pushEvent("remove_layer", { id: el.dataset.id });
          }
        });

        ctx.root.querySelector("#btn-add-layer").addEventListener("click", () => {
          ctx.pushEvent("add_layer", {});
        });

        // ── Server-pushed events ─────────────────────────────────────────────────
        ctx.handleEvent("layers_updated", (layers) => {
          currentLayers = layers;
          renderLayers(layers);
        });

        ctx.handleEvent("data_options", (opts) => {
          currentDataOptions = opts;
          renderLayers(currentLayers);
        });

        // Sync global fields from server (other connected clients, or server
        // corrections). Guard against clobbering the focused input.
        ctx.handleEvent("global_updated", (global) => {
          currentGlobal = global;
          const active = document.activeElement;
          [
            ["#global-title", "title"],
            ["#global-width", "width"],
            ["#global-height", "height"]
          ].forEach(([sel, key]) => {
            const el = ctx.root.querySelector(sel);
            if (el && el !== active) el.value = global[key] || "";
          });
        });

        // Flush any in-progress input before Livebook evaluates the cell.
        // Mirrors the kino_vega_lite pattern: dispatch change + input so both
        // select and text input listeners fire.
        ctx.handleSync(() => {
          const el = document.activeElement;
          if (el) {
            el.dispatchEvent(new Event("change", { bubbles: true }));
            el.dispatchEvent(new Event("input",  { bubbles: true }));
          }
        });
      }
      """
    end
  end
end

if Code.ensure_loaded?(Kino.JS) do
  defmodule Plotly.Kino.PlotlyLive do
    @moduledoc """
    Reactive Plotly chart for Livebook via Kino.JS.Live.
    Call push/2 to update the chart after the initial render.
    Call subscribe/2–4 to receive Plotly events (click, hover, relayout, selected).

    Animation support: frames stored in `fig.frames` are registered via
    `Plotly.addFrames` on initial render, enabling `Plotly.animate` calls.
    """

    use Kino.JS
    use Kino.JS.Live

    @plotly_version Application.compile_env(:plotly_ex, [:plotly_js, :version], "2.35.2")

    @doc """
    Create a new live (reactive) Plotly chart widget.

    Returns a `Kino.JS.Live` struct that renders immediately in Livebook.
    Use `push/2` to update the chart data and `subscribe/2` to receive browser events.

    ## Examples

        fig = Plotly.scatter(data, x: "date", y: "price", title: "Live Feed")
        chart = Plotly.Kino.PlotlyLive.new(fig)

        # Later, push an update without re-rendering the cell
        new_fig = Plotly.scatter(updated_data, x: "date", y: "price")
        Plotly.Kino.PlotlyLive.push(chart, new_fig)
    """
    def new(%Plotly.Figure{} = fig) do
      Kino.JS.Live.new(__MODULE__, fig)
    end

    @doc """
    Push a new figure to the live widget, updating the chart in place. Returns `:ok`.

    ## Examples

        chart = Plotly.Kino.PlotlyLive.new(initial_figure)

        # In a loop or after receiving new data:
        Enum.each(1..10, fn i ->
          updated = Plotly.scatter(data_at(i), x: "x", y: "y")
          Plotly.Kino.PlotlyLive.push(chart, updated)
          Process.sleep(500)
        end)
    """
    def push(kino, %Plotly.Figure{} = fig) do
      Kino.JS.Live.cast(kino, {:update, fig})
    end

    @doc """
    Subscribe to Plotly browser events from the live chart.

    All four arities send `{tag, payload_map}` messages when events fire.

    ## Arities

    - `subscribe(kino, tag)` — subscribe `self()` to all events, tagged `tag`
    - `subscribe(kino, tag, filter)` — subscribe `self()` filtered to one event type
    - `subscribe(kino, pid, tag)` — subscribe an explicit `pid` to all events
    - `subscribe(kino, pid, tag, filter)` — subscribe explicit `pid` with filter

    ## Filter atoms

    - `:click` — user clicks a data point (`"plotly_click"`)
    - `:hover` — user hovers over a data point (`"plotly_hover"`)
    - `:relayout` — user zooms, pans, or resizes (`"plotly_relayout"`)
    - `:selected` — user box/lasso selects points (`"plotly_selected"`)

    ## Payload

    Each message is `{tag, payload_map}` where `payload["type"]` is the event
    name and `payload["data"]` holds event-specific fields. For click/hover,
    `payload["data"]["points"]` is a list of maps with `x`, `y`, `curveNumber`, etc.

    ## Examples

        chart = Plotly.Kino.PlotlyLive.new(fig)

        # All events
        Plotly.Kino.PlotlyLive.subscribe(chart, :chart_events)

        # Only clicks
        Plotly.Kino.PlotlyLive.subscribe(chart, :clicks, :click)

        receive do
          {:clicks, %{"type" => "plotly_click", "data" => %{"points" => [pt | _]}}} ->
            IO.inspect(pt, label: "clicked point")
        end

        # Forward to another process
        Plotly.Kino.PlotlyLive.subscribe(chart, handler_pid, :chart_events)
    """
    def subscribe(kino, tag) when is_atom(tag) do
      Kino.JS.Live.cast(kino, {:subscribe, self(), tag, :all})
    end

    def subscribe(kino, tag, filter) when is_atom(tag) do
      Kino.JS.Live.cast(kino, {:subscribe, self(), tag, normalize_filter(filter)})
    end

    def subscribe(kino, pid, tag) when is_pid(pid) and is_atom(tag) do
      Kino.JS.Live.cast(kino, {:subscribe, pid, tag, :all})
    end

    def subscribe(kino, pid, tag, filter) when is_pid(pid) and is_atom(tag) do
      Kino.JS.Live.cast(kino, {:subscribe, pid, tag, normalize_filter(filter)})
    end

    @doc false
    # Test helper: dispatch a synthetic event without a browser. Returns :ok.
    def dispatch_event(kino, payload) when is_map(payload) do
      Kino.JS.Live.cast(kino, {:dispatch_event, payload})
    end

    @impl true
    def init(fig, ctx) do
      {:ok, assign(ctx, figure: fig, subscribers: [])}
    end

    @impl true
    def handle_connect(ctx) do
      payload =
        Jason.encode!(%{
          figureJson: Plotly.Figure.to_json(ctx.assigns.figure),
          plotlyUrl: "https://cdn.plot.ly/plotly-#{@plotly_version}.min.js"
        })

      {:ok, payload, ctx}
    end

    @impl true
    def handle_cast({:update, fig}, ctx) do
      broadcast_event(ctx, "update", Plotly.Figure.to_json(fig))
      {:noreply, assign(ctx, figure: fig)}
    end

    @impl true
    def handle_cast({:subscribe, pid, tag, filter}, ctx) do
      {:noreply, assign(ctx, subscribers: [{pid, tag, filter} | ctx.assigns.subscribers])}
    end

    @impl true
    def handle_cast({:dispatch_event, payload}, ctx) do
      forward_to_subscribers(payload, ctx)
      {:noreply, ctx}
    end

    @impl true
    def handle_event("plotly_event", payload_json, ctx) when is_binary(payload_json) do
      case Jason.decode(payload_json) do
        {:ok, payload} -> forward_to_subscribers(payload, ctx)
        _ -> :ok
      end

      {:noreply, ctx}
    end

    @event_type_map %{
      click: "plotly_click",
      hover: "plotly_hover",
      relayout: "plotly_relayout",
      selected: "plotly_selected"
    }

    defp normalize_filter(:all), do: :all
    defp normalize_filter(type) when is_atom(type), do: Map.fetch!(@event_type_map, type)

    defp forward_to_subscribers(%{"type" => event_type} = payload, ctx) do
      for {pid, tag, filter} <- ctx.assigns.subscribers,
          filter == :all or filter == event_type do
        send(pid, {tag, payload})
      end
    end

    defp forward_to_subscribers(payload, ctx) do
      for {pid, tag, _filter} <- ctx.assigns.subscribers do
        send(pid, {tag, payload})
      end
    end

    asset "main.js" do
      """
      export function init(ctx, payloadJson) {
        const { figureJson, plotlyUrl } = JSON.parse(payloadJson);

        loadScript(plotlyUrl).then(async () => {
          const fig = resolveRawJS(JSON.parse(figureJson));
          const locale = fig.config && fig.config.locale;
          if (locale) {
            const version = (plotlyUrl.match(/plotly-([\\d.]+)\\.min\\.js/) || [])[1];
            if (version) {
              await loadScript(`https://cdn.jsdelivr.net/npm/plotly.js@${version}/dist/plotly-locale-${locale}.min.js`);
            }
          }
          if (figureJson.includes('$')) await loadMathJax();
          Plotly.newPlot(ctx.root, fig.data || [], resolveTemplate(fig.layout), fig.config || {});
          if (fig.frames && fig.frames.length > 0) {
            Plotly.addFrames(ctx.root, fig.frames);
          }
          registerPlotlyEvents(ctx);
        });

        ctx.handleEvent("update", async (newFigureJson) => {
          const newFig = resolveRawJS(JSON.parse(newFigureJson));
          const locale = newFig.config && newFig.config.locale;
          if (locale) {
            const version = (plotlyUrl.match(/plotly-([\\d.]+)\\.min\\.js/) || [])[1];
            if (version) {
              await loadScript(`https://cdn.jsdelivr.net/npm/plotly.js@${version}/dist/plotly-locale-${locale}.min.js`);
            }
          }
          if (newFigureJson.includes('$')) await loadMathJax();
          Plotly.react(ctx.root, newFig.data || [], resolveTemplate(newFig.layout), newFig.config || {});
        });
      }

      async function loadMathJax() {
        if (window.MathJax && window.MathJax.typesetPromise) return;
        window.MathJax = {
          tex: { inlineMath: [['$', '$']] },
          svg: { fontCache: 'local' },
          startup: { typeset: false }
        };
        await loadScript('https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js');
        if (window.MathJax && window.MathJax.startup) {
          await window.MathJax.startup.promise;
        }
      }

      function resolveRawJS(value) {
        if (value === null || value === undefined) return value;
        if (Array.isArray(value)) return value.map(resolveRawJS);
        if (typeof value === 'object') {
          if ('__rawjs__' in value) {
            try { return new Function('return (' + value['__rawjs__'] + ')')(); } catch(e) { return undefined; }
          }
          const out = {};
          for (const [k, v] of Object.entries(value)) out[k] = resolveRawJS(v);
          return out;
        }
        return value;
      }

      function registerPlotlyEvents(ctx) {
        const events = ["plotly_click", "plotly_hover", "plotly_relayout", "plotly_selected"];
        events.forEach(function(eventName) {
          ctx.root.on(eventName, function(data) {
            ctx.pushEvent("plotly_event", JSON.stringify({
              type: eventName,
              data: serializePlotlyEvent(data)
            }));
          });
        });
      }

      function serializePlotlyEvent(data) {
        if (!data) return null;
        if (data.points) {
          return {
            points: data.points.map(function(p) {
              return {
                x: p.x, y: p.y, z: p.z,
                curveNumber: p.curveNumber,
                pointNumber: p.pointNumber,
                pointIndex: p.pointIndex,
                text: p.text,
                customdata: p.customdata,
                name: p.data && p.data.name,
                bbox: p.bbox
              };
            })
          };
        }
        // relayout / other events — plain object, safe to JSON round-trip
        try {
          return JSON.parse(JSON.stringify(data));
        } catch (_) {
          return { error: "unserializable" };
        }
      }

      function resolveTemplate(layout) {
        if (!layout) return {};
        const t = layout.template;
        if (typeof t === "string" && Plotly.templates && Plotly.templates[t]) {
          return Object.assign({}, layout, { template: Plotly.templates[t] });
        }
        return layout;
      }

      function loadScript(src) {
        return new Promise((resolve) => {
          const existing = document.querySelector(`script[src="${src}"]`);
          if (existing) return resolve();
          if (src.includes("plotly-") && !src.includes("locale") && window.Plotly) return resolve();
          const s = document.createElement("script");
          s.src = src;
          s.onload = resolve;
          s.onerror = resolve;
          document.head.appendChild(s);
        });
      }
      """
    end
  end
end

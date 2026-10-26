if Code.ensure_loaded?(Kino.JS) do
  defmodule Plotly.Kino.PlotlyLive do
    @moduledoc """
    Reactive Plotly chart for Livebook via Kino.JS.Live.
    Call push/2 to update the chart after the initial render.
    Call subscribe/2–4 to receive Plotly events (click, hover, unhover, relayout, selected).

    Animation support: frames stored in `fig.frames` are registered via
    `Plotly.addFrames` on initial render, enabling `Plotly.animate` calls.
    """

    use Kino.JS, assets_path: "priv/plotly_js", entrypoint: "plotly_live.js"
    use Kino.JS.Live

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
    - `:unhover` — cursor leaves a hovered point or the plot (`"plotly_unhover"`)
    - `:relayout` — user zooms, pans, or resizes (`"plotly_relayout"`)
    - `:selected` — user box/lasso selects points (`"plotly_selected"`)

    ## Payload

    Each message is `{tag, payload_map}` where `payload["type"]` is the event
    name and `payload["data"]` holds event-specific fields. For click/hover,
    `payload["data"]["points"]` is a list of maps with `x`, `y`, `z`,
    `curveNumber`, `pointNumber`, `pointIndex`, `text`, `customdata`, `name`,
    `bbox`, `xPixel`, and `yPixel`. Point pixels refer to the point centre;
    top-level `data["xPixel"]`/`data["yPixel"]` refer to the cursor. Top-level
    `xvals`/`yvals` contain axis data values (including date/category strings).
    Every listed field is present, with `nil` for missing upstream values.
    Anywhere events have an empty `points` list. Unhover and selection use
    the same point contract; relayout retains its original JSON shape.

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
          figureJson: Plotly.Figure.to_render_json(ctx.assigns.figure),
          plotlyUrls: Plotly.PlotlyJS.kino_source_urls(),
          version: Plotly.PlotlyJS.version()
        })

      {:ok, payload, ctx}
    end

    @impl true
    def handle_cast({:update, fig}, ctx) do
      broadcast_event(ctx, "update", Plotly.Figure.to_render_json(fig))
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
      unhover: "plotly_unhover",
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
  end
end

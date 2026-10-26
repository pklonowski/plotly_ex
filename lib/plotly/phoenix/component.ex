if Code.ensure_loaded?(Phoenix.Component) do
  defmodule Plotly.Phoenix.Component do
    @moduledoc """
    Phoenix function component for embedding Plotly charts.

    ## Events and math

    The hook forwards `plotly_click`, `plotly_hover`, `plotly_unhover`,
    `plotly_selected`, and `plotly_relayout` as `"plotly_event"` with `type` and
    `data`. Point events include `points`, `xvals`, `yvals`, `xPixel`, `yPixel`.
    Each point includes `x`, `y`, `z`, `curveNumber`, `pointNumber`, `pointIndex`,
    `text`, `customdata`, `name`, `bbox`, `xPixel`, and `yPixel`.
    Top-level pixels locate the cursor; point pixels locate the point centre.
    Missing values are `nil`; anywhere events have `points: []`. Axis values
    preserve date/category strings. Relayout keeps its original JSON shape.

    The LiveView hook loads MathJax 4 on demand before rendering figures whose
    JSON contains `$`. An existing MathJax 3/4 engine is reused.

    ## Setup

    1. *(Optional)* Add a `<script>` tag to your app layout if you want to pre-load
       plotly.js yourself (e.g. from a CDN). If omitted, the hook and `static_plot/2`
       will load it automatically via the CDN → jsdelivr → bundled fallback chain.

       To enable the bundled fallback (served locally), mount the plug in your router:

           forward "/plotly_ex", Plotly.Phoenix.Plug

    2. Register the hook in `assets/js/app.js`:

           import { PlotlyChart } from "../../deps/plotly_ex/priv/static/plotly_hook.js"
           let liveSocket = new LiveSocket("/live", Socket, {
             hooks: { PlotlyChart }
           })

    3. Use in LiveView templates: `<Plotly.Phoenix.Component.plot id="my-chart" figure={@figure} />`
    """

    use Phoenix.Component

    attr(:figure, :any, required: true, doc: "A `Plotly.Figure` struct to render.")

    attr(:id, :string,
      required: true,
      doc: "DOM ID for the chart container (must be unique per page)."
    )

    attr(:class, :string, default: nil, doc: "Optional CSS class for the container div.")

    @doc """
    Render a Plotly chart in a Phoenix LiveView template.

    The chart updates automatically when the `figure` assign changes — the hook
    calls `Plotly.react` on each DOM patch, so only changed data is re-rendered.

    ## Examples

        # In your LiveView template (.heex):
        <Plotly.Phoenix.Component.plot id="revenue-chart" figure={@figure} />

        # With a CSS class for sizing:
        <Plotly.Phoenix.Component.plot
          id="sales-chart"
          figure={@figure}
          class="h-96 w-full"
        />

        # In your LiveView module — update the chart by reassigning @figure:
        def handle_event("refresh", _params, socket) do
          {:noreply, assign(socket, figure: build_figure())}
        end
    """
    def plot(assigns) do
      assigns =
        assign(assigns,
          plotly_urls: Jason.encode!(Plotly.PlotlyJS.source_urls())
        )

      ~H"""
      <div
        id={@id}
        phx-hook="PlotlyChart"
        data-figure={Plotly.Figure.to_render_json(@figure)}
        data-plotly-urls={@plotly_urls}
        {if @class, do: [class: @class], else: []}
      ></div>
      """
    end

    @doc """
    Render a Plotly chart as static HTML for use in controller-rendered (non-LiveView) templates.
    Returns `{:safe, html}`.

    No manual `<script>` tag is required — the inline loader walks the CDN → jsdelivr → bundled
    fallback chain automatically. To enable the bundled fallback, mount `Plotly.Phoenix.Plug`
    in your router: `forward "/plotly_ex", Plotly.Phoenix.Plug`.

    ## Example

        # Controller:
        render(conn, :index, figure: Plotly.bar(data, x: "month", y: "sales"))

        # Template:
        <%= Plotly.Phoenix.Component.static_plot(@figure, id: "my-chart") %>
    """
    def static_plot(%Plotly.Figure{} = figure, opts \\ []) do
      id = Keyword.get(opts, :id, "plotly-chart")
      safe_id = Regex.replace(~r/[^a-zA-Z0-9_-]/, id, "")
      json = Plotly.Figure.to_render_json(figure)
      urls = Jason.encode!(Plotly.PlotlyJS.source_urls())
      warn = Plotly.PlotlyJS.warning_message("the local bundle")

      warn_json = Jason.encode!(warn)

      {:safe,
       "<div id=\"#{safe_id}\"></div>" <>
         "<script>(function(){" <>
         "var urls=#{urls};" <>
         "var fig=#{json};" <>
         "function load(i){" <>
         "if(window.Plotly){return Plotly.newPlot(\"#{safe_id}\",fig.data,fig.layout,fig.config);}" <>
         "if(i>=urls.length){console.error(\"plotly_ex: all plotly.js sources failed\");return;}" <>
         "var s=document.createElement(\"script\");" <>
         "s.src=urls[i];" <>
         "s.onload=function(){if(i>0)console.warn(#{warn_json});load(i);};" <>
         "s.onerror=function(){load(i+1);};" <>
         "document.head.appendChild(s);}" <>
         "load(0);" <>
         "})();</script>"}
    end
  end
end

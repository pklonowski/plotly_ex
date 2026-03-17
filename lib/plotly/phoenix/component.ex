if Code.ensure_loaded?(Phoenix.Component) do
  defmodule Plotly.Phoenix.Component do
    @moduledoc """
    Phoenix function component for embedding Plotly charts.

    ## Setup

    1. Add to your app layout (use the version matching `config :plotly_ex, :plotly_js, version: "x.y.z"`):
       `<script src="https://cdn.plot.ly/plotly-VERSION.min.js"></script>`
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
      ~H"""
      <div
        id={@id}
        phx-hook="PlotlyChart"
        data-figure={Plotly.Figure.to_json(@figure)}
        {if @class, do: [class: @class], else: []}
      ></div>
      """
    end

    @doc """
    Render a Plotly chart as static HTML for use in controller-rendered (non-LiveView) templates.
    Returns `{:safe, html}`.

    Requires `<script src="https://cdn.plot.ly/plotly-VERSION.min.js"></script>` in the layout.

    ## Example

        # Controller:
        render(conn, :index, figure: Plotly.bar(data, x: "month", y: "sales"))

        # Template:
        <%= Plotly.Phoenix.Component.static_plot(@figure, id: "my-chart") %>
    """
    def static_plot(%Plotly.Figure{} = figure, opts \\ []) do
      id = Keyword.get(opts, :id, "plotly-chart")
      safe_id = Regex.replace(~r/[^a-zA-Z0-9_-]/, id, "")
      json = Plotly.Figure.to_json(figure)

      {:safe,
       ~s[<div id="#{safe_id}"></div><script>const fig=#{json};Plotly.newPlot("#{safe_id}",fig.data,fig.layout,fig.config);</script>]}
    end
  end
end

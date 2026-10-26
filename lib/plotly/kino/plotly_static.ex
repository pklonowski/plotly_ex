if Code.ensure_loaded?(Kino.JS) do
  defmodule Plotly.Kino.PlotlyStatic do
    @moduledoc """
    Static (non-updating) Plotly chart for Livebook via Kino.JS.
    Use `Plotly.Kino.PlotlyLive` for reactive/streaming charts.

    ## Configuration

    The Plotly.js version and source are baked in at compile time via `Application.compile_env`:

    ```elixir
    # config/config.exs
    config :plotly_ex, :plotly_js,
      version: "4.1.2",   # default — the version of plotly.js loaded from CDN
      source: :cdn         # :cdn (default) or :bundled
    ```

    In Kino the offline fallback is the co-located `./plotly.min.js` asset, served by
    Livebook from this widget's asset archive (there is no Phoenix endpoint).
    """

    use Kino.JS, assets_path: "priv/plotly_js", entrypoint: "plotly_static.js"

    @doc """
    Create a static (non-reactive) Plotly chart widget. Renders once; does not update after creation.

    For a chart that can be updated after rendering, use `Plotly.Kino.PlotlyLive.new/1` instead.

    ## Examples

        Plotly.bar(data, x: "month", y: "sales", title: "Revenue")
        |> Plotly.Kino.PlotlyStatic.new()

        # Figures also auto-render in Livebook via the Kino.Render protocol —
        # you normally don't need to call this function directly:
        Plotly.scatter(data, x: "x", y: "y")
        |> Plotly.show()
    """
    def new(%Plotly.Figure{} = fig) do
      payload =
        Jason.encode!(%{
          figureJson: Plotly.Figure.to_render_json(fig),
          plotlyUrls: Plotly.PlotlyJS.kino_source_urls(),
          version: Plotly.PlotlyJS.version()
        })

      Kino.JS.new(__MODULE__, payload)
    end
  end

  defimpl Kino.Render, for: Plotly.Figure do
    def to_livebook(fig) do
      fig |> Plotly.Kino.PlotlyStatic.new() |> Kino.Render.to_livebook()
    end
  end
end

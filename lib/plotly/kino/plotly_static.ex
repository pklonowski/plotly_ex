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
      version: "2.35.2",   # default — the version of plotly.js loaded from CDN
      source: :cdn         # :cdn (default) or :bundled
    ```

    **Note:** `:bundled` source is not supported in Kino (there is no Phoenix endpoint to serve
    a local file). If configured, it warns and falls back to `:cdn`.
    """

    use Kino.JS

    # Baked in at compile time — runtime config changes require recompilation.
    @plotly_source Application.compile_env(:plotly_ex, [:plotly_js, :source], :cdn)
    @plotly_version Application.compile_env(:plotly_ex, [:plotly_js, :version], "2.35.2")

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
          figureJson: Plotly.Figure.to_json(fig),
          plotlyUrl: plotly_url()
        })

      Kino.JS.new(__MODULE__, payload)
    end

    asset "main.js" do
      """
      export function init(ctx, payloadJson) {
        const { figureJson, plotlyUrl } = JSON.parse(payloadJson);
        const fig = JSON.parse(figureJson);

        loadScript(plotlyUrl).then(async () => {
          const resolved = resolveRawJS(fig);
          const locale = resolved.config && resolved.config.locale;
          if (locale) {
            const version = (plotlyUrl.match(/plotly-([\\d.]+)\\.min\\.js/) || [])[1];
            if (version) {
              await loadScript(`https://cdn.jsdelivr.net/npm/plotly.js@${version}/dist/plotly-locale-${locale}.min.js`);
            }
          }
          if (figureJson.includes('$')) await loadMathJax();
          Plotly.newPlot(ctx.root, resolved.data || [], resolved.layout || {}, resolved.config || {});
        });
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

      function loadScript(src) {
        return new Promise((resolve) => {
          const existing = document.querySelector(`script[src="${src}"]`);
          if (existing) return resolve();
          if (!src.includes("locale") && window.Plotly) return resolve();
          const s = document.createElement("script");
          s.src = src;
          s.onload = resolve;
          s.onerror = resolve;
          document.head.appendChild(s);
        });
      }
      """
    end

    defp plotly_url do
      case @plotly_source do
        :cdn ->
          "https://cdn.plot.ly/plotly-#{@plotly_version}.min.js"

        :bundled ->
          # This module only compiles when Kino is present. In a Kino/Livebook
          # context there is no Phoenix endpoint, so the :bundled local path
          # ("/plotly/plotly.min.js") can never be served. Warn and fall back to CDN.
          require Logger

          Logger.warning(
            "plotly_ex: :bundled source is not supported in Kino. Falling back to CDN."
          )

          "https://cdn.plot.ly/plotly-#{@plotly_version}.min.js"
      end
    end
  end

  defimpl Kino.Render, for: Plotly.Figure do
    def to_livebook(fig) do
      fig |> Plotly.Kino.PlotlyStatic.new() |> Kino.Render.to_livebook()
    end
  end
end

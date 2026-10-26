defmodule Plotly.PlotlyJS do
  @moduledoc """
  Single source of truth for the Plotly.js version and the ordered list of
  source URLs used to load it.

  ## Loading & fallback

  By default plotly.js is loaded from a CDN, falling back automatically when a
  source is unreachable:

      1. cdn.plot.ly   (pinned, default)
      2. jsdelivr      (mirror)
      3. local bundle  (`/plotly_ex/plotly.min.js?v=4.1.2`, served by `Plotly.Phoenix.Plug`
         or as a Kino asset) — an offline copy vendored with this library.

  Phoenix bundle URLs include the vendored version to invalidate immutable
  browser caches on upgrade. `bundled_path/0` remains the configured route.

  Each fallback emits a `console.warn` (browser) / `Logger.warning` (server)
  explaining what happened. When `source: :bundled` is configured, only the
  local bundle is used and no fallback warning is emitted.

  ## Configuration (compile time)

      config :plotly_ex, :plotly_js,
        version: "4.1.2",                       # default — must match the vendored bundle
        source: :cdn,                           # :cdn (default) or :bundled
        bundled_path: "/plotly_ex/plotly.min.js" # public URL the Phoenix Plug serves
  """

  @compatible_version "4.1.2"

  @version Application.compile_env(:plotly_ex, [:plotly_js, :version], @compatible_version)
  @source Application.compile_env(:plotly_ex, [:plotly_js, :source], :cdn)
  @bundled_path Application.compile_env(
                  :plotly_ex,
                  [:plotly_js, :bundled_path],
                  "/plotly_ex/plotly.min.js"
                )

  @doc "The plotly.js version this library is built and tested against."
  def compatible_version, do: @compatible_version

  @doc "The configured plotly.js version (defaults to `compatible_version/0`)."
  def version, do: @version

  @doc "The configured load source: `:cdn` (default) or `:bundled`."
  def source, do: @source

  @doc "Public URL the bundled copy is served at (Phoenix)."
  def bundled_path, do: @bundled_path

  @doc "cdn.plot.ly URL for the given version."
  def cdn_url(version \\ @version), do: "https://cdn.plot.ly/plotly-#{version}.min.js"

  @doc "jsdelivr mirror URL for the given version."
  def jsdelivr_url(version \\ @version),
    do: "https://cdn.jsdelivr.net/npm/plotly.js@#{version}/dist/plotly.min.js"

  @doc "Filesystem path to the vendored bundle."
  def bundled_priv_path,
    do: Application.app_dir(:plotly_ex, ["priv", "plotly_js", "plotly.min.js"])

  @doc "Ordered list of URLs to try, based on `source/0`."
  def source_urls do
    uri = URI.parse(@bundled_path)

    query =
      URI.query_decoder(uri.query || "")
      |> Enum.reject(fn {key, _value} -> key == "v" end)
      |> Enum.concat([{"v", @compatible_version}])
      |> URI.encode_query()

    bundled_url = URI.to_string(%{uri | query: query})

    case @source do
      :bundled -> [bundled_url]
      _ -> [cdn_url(), jsdelivr_url(), bundled_url]
    end
  end

  @doc """
  Ordered list of plotly.js URLs for Kino widgets.

  Identical ordering to `source_urls/0`, but the offline fallback is the
  co-located Kino asset URL `"./plotly.min.js"` (served by Livebook from the
  widget's asset archive) rather than the Phoenix public path.
  """
  def kino_source_urls do
    case @source do
      :bundled -> ["./plotly.min.js"]
      _ -> [cdn_url(), jsdelivr_url(), "./plotly.min.js"]
    end
  end

  @doc "Canonical warning shown when a fallback source is used."
  def warning_message(engaged_url) do
    "plotly_ex: primary plotly.js source was unreachable; fell back to " <>
      "#{engaged_url} (plotly.js #{@version}). The local bundle is an offline " <>
      "copy vendored with plotly_ex. To silence this, host plotly.js yourself or " <>
      "set `config :plotly_ex, :plotly_js, source: :bundled`."
  end
end

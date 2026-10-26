if Code.ensure_loaded?(Plug) do
  defmodule Plotly.Phoenix.Plug do
    @moduledoc """
    Serves the vendored plotly.js bundle (the offline fallback) from
    `priv/plotly_js/plotly.min.js`.

    Mount it in your router so the fallback URL resolves:

        forward "/plotly_ex", Plotly.Phoenix.Plug

    This makes `/plotly_ex/plotly.min.js` available. The last entry in
    `Plotly.PlotlyJS.source_urls/0` adds a vendored-version query parameter so
    the immutable browser cache requests a fresh bundle after upgrades.
    """
    @behaviour Plug
    import Plug.Conn

    @impl true
    def init(opts), do: opts

    @impl true
    def call(%Plug.Conn{path_info: ["plotly.min.js"]} = conn, _opts) do
      conn
      |> put_resp_content_type("text/javascript")
      |> put_resp_header("cache-control", "public, max-age=31536000, immutable")
      |> send_file(200, Plotly.PlotlyJS.bundled_priv_path())
      |> halt()
    end

    def call(conn, _opts), do: conn |> send_resp(404, "not found") |> halt()
  end
end

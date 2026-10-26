defmodule Plotly.BundleCacheTest do
  use ExUnit.Case, async: true

  alias Plotly.PlotlyJS

  test "the Phoenix fallback URL identifies the vendored version across upgrades" do
    fallback = PlotlyJS.source_urls() |> List.last() |> URI.parse()

    assert fallback.path == PlotlyJS.bundled_path()

    assert URI.decode_query(fallback.query || "")["v"] == PlotlyJS.compatible_version(),
           "the immutable local bundle needs a versioned URL so a cached v3 bundle cannot satisfy a v4 load"
  end

  @tag :requires_phoenix
  test "the bundle plug serves versioned requests with its immutable cache policy" do
    conn =
      Plug.Test.conn(:get, "/plotly.min.js?v=#{PlotlyJS.compatible_version()}")
      |> Plotly.Phoenix.Plug.call(Plotly.Phoenix.Plug.init([]))

    assert conn.status == 200
    assert conn.resp_body =~ "plotly.js v#{PlotlyJS.compatible_version()}"

    assert Plug.Conn.get_resp_header(conn, "cache-control") == [
             "public, max-age=31536000, immutable"
           ]
  end
end

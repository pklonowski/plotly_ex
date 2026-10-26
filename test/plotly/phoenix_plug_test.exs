defmodule Plotly.Phoenix.PlugTest do
  use ExUnit.Case, async: true
  @moduletag :requires_phoenix
  import Plug.Test
  import Plug.Conn

  @opts Plotly.Phoenix.Plug.init([])

  test "serves plotly.min.js with javascript content-type" do
    conn = conn(:get, "/plotly.min.js") |> Plotly.Phoenix.Plug.call(@opts)
    assert conn.status == 200
    assert get_resp_header(conn, "content-type") |> hd() =~ "javascript"
    assert conn.resp_body =~ "plotly.js v4.1.2"
  end

  test "returns 404 for unknown paths" do
    conn = conn(:get, "/nope.js") |> Plotly.Phoenix.Plug.call(@opts)
    assert conn.status == 404
  end
end

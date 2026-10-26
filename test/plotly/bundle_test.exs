defmodule Plotly.BundleTest do
  use ExUnit.Case, async: true

  @bundle Path.join([File.cwd!(), "priv", "plotly_js", "plotly.min.js"])

  test "vendored bundle exists and is plotly.js 4.1.2" do
    assert File.exists?(@bundle)
    head = File.stream!(@bundle, 4096, []) |> Enum.take(1) |> List.first()
    assert head =~ "plotly.js v4.1.2"
  end

  test "old root-of-priv bundle is gone" do
    refute File.exists?(Path.join([File.cwd!(), "priv", "plotly.min.js"]))
  end

  test "mix.exs packages the plotly_js directory" do
    files = Mix.Project.config()[:package][:files]
    assert "priv/plotly_js" in files
  end
end

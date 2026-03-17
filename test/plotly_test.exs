defmodule PlotlyTest do
  use ExUnit.Case, async: true
  doctest Plotly

  @data [%{"x" => 1, "y" => 2}, %{"x" => 3, "y" => 4}]

  describe "figure/1" do
    test "returns an empty Figure with defaults" do
      assert %Plotly.Figure{data: [], layout: %{}} = Plotly.figure()
    end

    test "accepts layout opts" do
      fig = Plotly.figure(layout: %{title: "Hi"})
      assert fig.layout == %{title: "Hi"}
    end
  end

  describe "Express delegates" do
    test "scatter/2 delegates to Express" do
      fig = Plotly.scatter(@data, x: "x", y: "y")
      assert %Plotly.Figure{} = fig
      assert length(fig.data) == 1
    end

    test "scatter/1 (no opts) raises KeyError — :x is required" do
      assert_raise KeyError, fn -> Plotly.scatter(@data) end
    end

    test "bar/2 delegates to Express" do
      fig = Plotly.bar(@data, x: "x", y: "y")
      assert %Plotly.Figure{} = fig
    end

    test "line/2 delegates to Express with mode=lines" do
      fig = Plotly.line(@data, x: "x", y: "y")
      [trace] = fig.data
      assert trace.mode == "lines"
    end
  end

  describe "show/1" do
    # This test only runs when Kino is NOT available (e.g. in a barebones env).
    # When Kino is present this block is skipped; the positive case is below.
    test "raises a descriptive error when Kino is not available" do
      unless Code.ensure_loaded?(Plotly.Kino.PlotlyLive) do
        assert_raise RuntimeError, ~r/requires the :kino dependency/, fn ->
          Plotly.show(Plotly.figure())
        end
      end
    end

    @tag :requires_kino
    test "returns a Kino struct when Kino is available" do
      widget = Plotly.show(Plotly.figure())
      assert is_struct(widget)
    end
  end

  describe "Chart Studio deprecation warnings" do
    test "warns when deprecated Chart Studio config keys are used" do
      output =
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          Plotly.Figure.new(config: %{showLink: true, plotlyServerURL: "https://example.com"})
        end)

      assert output =~ "Chart Studio integration is deprecated"
      assert output =~ ":plotlyServerURL"
      assert output =~ ":showLink"
    end
  end
end

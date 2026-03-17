defmodule Plotly.PhoenixTest do
  use ExUnit.Case, async: true
  @moduletag :requires_phoenix

  import Phoenix.LiveViewTest

  describe "Plotly.Phoenix.Component.plot/1" do
    test "renders a div with phx-hook attribute" do
      fig = Plotly.Figure.new(layout: %{title: "Test"})
      html = render_component(&Plotly.Phoenix.Component.plot/1, id: "my-chart", figure: fig)

      assert html =~ ~s[phx-hook="PlotlyChart"]
      assert html =~ ~s[id="my-chart"]
    end

    test "data-figure attribute contains valid JSON" do
      fig = Plotly.Figure.new(layout: %{title: "Hello"})
      html = render_component(&Plotly.Phoenix.Component.plot/1, id: "chart1", figure: fig)

      [_, json_escaped] = Regex.run(~r/data-figure="([^"]*)"/, html)
      # Phoenix HTML-encodes " as &quot; in attribute values
      json = String.replace(json_escaped, "&quot;", ~s["])
      decoded = Jason.decode!(json)
      assert decoded["layout"]["title"] == "Hello"
    end

    test "renders without class when class not provided" do
      fig = Plotly.Figure.new()
      html = render_component(&Plotly.Phoenix.Component.plot/1, id: "chart1", figure: fig)
      refute html =~ ~s[class="]
    end

    test "renders class attribute when provided" do
      fig = Plotly.Figure.new()

      html =
        render_component(&Plotly.Phoenix.Component.plot/1,
          id: "chart1",
          figure: fig,
          class: "h-96 w-full"
        )

      assert html =~ ~s[class="h-96 w-full"]
    end
  end

  describe "Plotly.Phoenix.Component.static_plot/2" do
    test "renders a div and script tag" do
      fig = Plotly.Figure.new(layout: %{title: "Test"})
      {:safe, html} = Plotly.Phoenix.Component.static_plot(fig, id: "my-chart")

      assert html =~ ~s[id="my-chart"]
      assert html =~ "<script>"
      assert html =~ "Plotly.newPlot"
    end

    test "embeds valid JSON figure data" do
      fig = Plotly.Figure.new(layout: %{title: "Hello"})
      {:safe, html} = Plotly.Phoenix.Component.static_plot(fig, id: "chart1")

      [_, json] = Regex.run(~r/const fig=(.+);Plotly/, html)
      decoded = Jason.decode!(json)
      assert decoded["layout"]["title"] == "Hello"
    end

    test "uses default id when not provided" do
      fig = Plotly.Figure.new()
      {:safe, html} = Plotly.Phoenix.Component.static_plot(fig)

      assert html =~ ~s[id="plotly-chart"]
    end

    test "returns {:safe, _} tuple (safe for templates without raw/1)" do
      fig = Plotly.Figure.new()
      result = Plotly.Phoenix.Component.static_plot(fig, id: "x")
      assert match?({:safe, _}, result)
    end
  end
end

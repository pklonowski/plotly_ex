defmodule PhxExWeb.PlotsLiveTest do
  use PhxExWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "mount" do
    test "renders the first plot title and code textarea", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "Scatter: Cities"
      assert html =~ "Plotly.scatter"
    end

    test "renders the nav with all 16 plot links", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "Bar: Monthly Sales"
      assert html =~ "Candlestick"
      assert html =~ "3D Surface"
      assert html =~ "Click Events"
    end
  end

  describe "nav selection" do
    test "clicking a nav button swaps the plot title", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      html = view |> element("button[phx-value-id='bar_monthly']") |> render_click()
      assert html =~ "Bar: Monthly Sales"
    end

    test "clicking a nav button swaps the code textarea content", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      html = view |> element("button[phx-value-id='bar_monthly']") |> render_click()
      assert html =~ "Plotly.bar"
    end

    test "the selected nav item is highlighted", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("button[phx-value-id='pie_budget']") |> render_click()
      assert has_element?(view, "button[phx-value-id='pie_budget'].bg-blue-100")
    end
  end

  describe "update_code" do
    test "updates the textarea without triggering eval", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      new_code = "Plotly.bar([], x: \"x\", y: \"y\")"
      view |> element("form#code-form") |> render_change(%{"code" => new_code})
      assert has_element?(view, "textarea", new_code)
    end
  end

  describe "execute" do
    test "valid code updates the figure and clears any error", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      view
      |> element("form#code-form")
      |> render_change(%{
        "code" => """
        alias Plotly.{Figure, Scatter}
        Figure.new()
        |> Figure.add_trace(Scatter.new(x: [1, 2], y: [3, 4]))
        |> Figure.update_layout(title: "Test")
        """
      })

      html = view |> element("button[phx-click='execute']") |> render_click()
      refute html =~ "id=\"error-msg\""
    end

    test "invalid code (syntax error) shows an error message", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      view
      |> element("form#code-form")
      |> render_change(%{"code" => "this is not valid elixir !!!"})

      html = view |> element("button[phx-click='execute']") |> render_click()
      assert html =~ "id=\"error-msg\""
    end

    test "code that returns a non-Figure shows an error", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("form#code-form") |> render_change(%{"code" => ":not_a_figure"})
      html = view |> element("button[phx-click='execute']") |> render_click()
      assert html =~ "id=\"error-msg\""
    end
  end

  describe "reset" do
    test "restores the original code", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      original_code_fragment = "Plotly.scatter"
      view |> element("form#code-form") |> render_change(%{"code" => "changed code"})
      html = view |> element("button[phx-click='reset']") |> render_click()
      assert html =~ original_code_fragment
    end

    test "clears the error after reset", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("form#code-form") |> render_change(%{"code" => ":bad"})
      view |> element("button[phx-click='execute']") |> render_click()
      html = view |> element("button[phx-click='reset']") |> render_click()
      refute html =~ "id=\"error-msg\""
    end
  end

  describe "plotly_event (click)" do
    test "a plotly_click event displays the last clicked point", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("button[phx-value-id='click_events']") |> render_click()

      html =
        render_hook(view, "plotly_event", %{
          "type" => "plotly_click",
          "data" => %{
            "points" => [
              %{
                "x" => 3,
                "y" => 5,
                "name" => "Gamma",
                "curveNumber" => 0,
                "pointNumber" => 2,
                "pointIndex" => 2
              }
            ]
          }
        })

      assert html =~ "x: 3"
      assert html =~ "y: 5"
    end

    test "non-click plotly events are ignored", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      html =
        render_hook(view, "plotly_event", %{
          "type" => "plotly_hover",
          "data" => %{"points" => [%{"x" => 1, "y" => 2}]}
        })

      refute html =~ "Last clicked point"
    end
  end

  describe "all 16 plots smoke test" do
    @plot_ids ~w(
      scatter_cities bar_monthly bar_grouped line_temp histogram
      box_scores pie_budget scatter_modes heatmap bubble
      filled_area candlestick surface_3d choropleth time_series click_events
    )

    test "each plot's default code evals to a Plotly.Figure on selection", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      for id <- @plot_ids do
        html = view |> element("button[phx-value-id='#{id}']") |> render_click()

        assert html =~ "main-chart",
               "Plot #{id} is missing the chart element"

        refute html =~ "id=\"error-msg\"",
               "Plot #{id} produced an eval error — check its code snippet"
      end
    end
  end

  describe "last_point cleared on navigation" do
    test "navigating away from click_events clears the last clicked point", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("button[phx-value-id='click_events']") |> render_click()

      render_hook(view, "plotly_event", %{
        "type" => "plotly_click",
        "data" => %{"points" => [%{"x" => 1, "y" => 2, "name" => "Alpha"}]}
      })

      html = view |> element("button[phx-value-id='scatter_cities']") |> render_click()
      refute html =~ "Last clicked point"
    end
  end
end

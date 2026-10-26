defmodule PhxExWeb.PlotsLive do
  use PhxExWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    plots = plots()
    first = hd(plots)

    {figure, error} =
      case eval_code(first.code) do
        {:ok, fig} -> {fig, nil}
        {:error, msg} -> {Plotly.Figure.new(), msg}
      end

    {:ok,
     assign(socket,
       plots: plots,
       current_id: first.id,
       edited_code: first.code,
       figure: figure,
       error: error,
       last_point: nil
     )}
  end

  @impl true
  def handle_event("select", %{"id" => id_str}, socket) do
    id = String.to_existing_atom(id_str)
    plot = Enum.find(socket.assigns.plots, &(&1.id == id))

    {figure, error} =
      case eval_code(plot.code) do
        {:ok, fig} -> {fig, nil}
        {:error, msg} -> {socket.assigns.figure, msg}
      end

    {:noreply,
     assign(socket,
       current_id: id,
       edited_code: plot.code,
       figure: figure,
       error: error,
       last_point: nil
     )}
  end

  def handle_event("update_code", %{"code" => code}, socket) do
    {:noreply, assign(socket, edited_code: code)}
  end

  def handle_event("execute", _params, socket) do
    case eval_code(socket.assigns.edited_code) do
      {:ok, figure} -> {:noreply, assign(socket, figure: figure, error: nil)}
      {:error, msg} -> {:noreply, assign(socket, error: msg)}
    end
  end

  def handle_event("reset", _params, socket) do
    plot = Enum.find(socket.assigns.plots, &(&1.id == socket.assigns.current_id))

    {figure, error} =
      case eval_code(plot.code) do
        {:ok, fig} -> {fig, nil}
        {:error, msg} -> {socket.assigns.figure, msg}
      end

    {:noreply, assign(socket, edited_code: plot.code, figure: figure, error: error)}
  end

  def handle_event("plotly_event", %{"type" => "plotly_click", "data" => data}, socket) do
    last_point = data |> Map.get("points", []) |> List.first()

    figure =
      if socket.assigns.current_id == :click_events && last_point do
        socket.assigns.figure
        |> Plotly.Figure.update_layout(
          annotations: [
            %{
              text: build_click_annotation(data),
              x: 0.01,
              y: 0.99,
              xref: "paper",
              yref: "paper",
              xanchor: "left",
              yanchor: "top",
              showarrow: false,
              align: "left",
              font: %{size: 10, family: "Courier New, monospace", color: "#1e40af"},
              bgcolor: "rgba(239, 246, 255, 0.95)",
              bordercolor: "#3b82f6",
              borderwidth: 1,
              borderpad: 8
            }
          ]
        )
      else
        socket.assigns.figure
      end

    {:noreply, assign(socket, last_point: last_point, figure: figure)}
  end

  def handle_event("plotly_event", _params, socket) do
    {:noreply, socket}
  end

  defp eval_code(code) do
    try do
      {result, _bindings} = Code.eval_string(code)

      if match?(%Plotly.Figure{}, result) do
        {:ok, result}
      else
        {:error, "Code must return a %Plotly.Figure{}, got: #{inspect(result)}"}
      end
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  defp current_plot(plots, id), do: Enum.find(plots, &(&1.id == id))

  defp build_click_annotation(data) do
    point = List.first(data["points"])
    sp = "&nbsp;"
    x = inspect(point["x"])
    y = inspect(point["y"])
    text = inspect(point["text"])
    name = inspect(point["name"])

    [
      ~s|handle_event("plotly_event",|,
      ~s|#{sp}#{sp}%{"type" => "plotly_click",|,
      ~s|#{sp}#{sp}#{sp}"data" => %{"points" => [|,
      ~s|#{sp}#{sp}#{sp}#{sp}#{sp}%{"x" => #{x}, "y" => #{y},|,
      ~s|#{sp}#{sp}#{sp}#{sp}#{sp}#{sp}#{sp}"text" => #{text},|,
      ~s|#{sp}#{sp}#{sp}#{sp}#{sp}#{sp}#{sp}"name" => #{name}}|,
      ~s|#{sp}#{sp}#{sp}#{sp}#{sp}]}},|,
      ~s|#{sp}#{sp}socket)|
    ]
    |> Kernel.++(pixel_annotation("Cursor", data) ++ pixel_annotation("Point", point))
    |> Enum.join("<br>")
  end

  defp pixel_annotation(label, %{"xPixel" => x, "yPixel" => y})
       when is_number(x) and is_number(y),
       do: ["#{label} pixels: (#{x}, #{y})"]

  defp pixel_annotation(_label, _data), do: []

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-screen overflow-hidden">
      <%!-- Sidebar nav --%>
      <nav class="w-56 flex-shrink-0 border-r bg-gray-50 overflow-y-auto p-4">
        <h1 class="text-base font-bold mb-4 text-gray-800">Plotly.ex Demo</h1>
        <ul class="space-y-1">
          <li :for={plot <- @plots}>
            <button
              phx-click="select"
              phx-value-id={plot.id}
              class={[
                "w-full text-left px-3 py-2 rounded text-sm transition-colors",
                if(plot.id == @current_id,
                  do: "bg-blue-100 text-blue-800 font-medium",
                  else: "text-gray-700 hover:bg-gray-100"
                )
              ]}
            >
              {plot.title}
            </button>
          </li>
        </ul>
        <div class="mt-4 pt-4 border-t border-gray-200">
          <a
            href="/static"
            class="block w-full text-left px-3 py-2 rounded text-sm text-gray-700 hover:bg-gray-100 transition-colors"
          >
            Static Plot Example
          </a>
        </div>
      </nav>

      <%!-- Main pane --%>
      <main class="flex-1 overflow-y-auto p-6">
        <h2 class="text-xl font-semibold mb-4 text-base-content">
          {current_plot(@plots, @current_id).title}
        </h2>

        <%!-- Chart --%>
        <div class="mb-4 border rounded">
          <Plotly.Phoenix.Component.plot
            id={"main-chart-#{@current_id}"}
            figure={@figure}
            class="h-96 w-full"
          />
        </div>

        <%!-- Syntax-highlighted code display --%>
        <div class="mb-2 rounded border overflow-auto text-sm">
          {Phoenix.HTML.raw(MDEx.to_html!("```elixir\n#{@edited_code}\n```"))}
        </div>

        <%!-- Editable code textarea --%>
        <form id="code-form" phx-change="update_code">
          <textarea
            name="code"
            phx-debounce="blur"
            rows="10"
            class="w-full font-mono text-sm border rounded p-2 bg-gray-900 text-green-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >{@edited_code}</textarea>
        </form>

        <%!-- Action buttons + error --%>
        <div class="flex items-center gap-3 mt-2">
          <button
            phx-click="execute"
            class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 text-sm font-medium"
          >
            Plot ▶
          </button>
          <button
            phx-click="reset"
            class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 text-sm"
          >
            Reset ↺
          </button>
          <span :if={@error} id="error-msg" class="text-red-600 text-sm">
            {@error}
          </span>
        </div>

        <%!-- Point info box — shown below buttons --%>
        <div :if={@last_point} class="mt-4 p-3 bg-gray-100 rounded text-sm text-gray-700">
          <strong>Last clicked point:</strong>
          x: {@last_point["x"]}, y: {@last_point["y"]}, name: {@last_point["name"]}
        </div>
      </main>
    </div>
    """
  end

  # ── Plot definitions ─────────────────────────────────────────────────────

  defp plots do
    [
      %{
        id: :scatter_cities,
        title: "Scatter: Cities",
        code: ~S"""
        cities = [
          %{"city" => "New York",    "population" => 8_336_817, "area" => 783.8},
          %{"city" => "Los Angeles", "population" => 3_979_576, "area" => 1_302.0},
          %{"city" => "Chicago",     "population" => 2_693_976, "area" => 606.1},
          %{"city" => "Houston",     "population" => 2_320_268, "area" => 1_777.0},
          %{"city" => "Phoenix",     "population" => 1_680_992, "area" => 1_340.0}
        ]
        Plotly.scatter(cities,
          x: "area",
          y: "population",
          title: "US Cities: Area vs Population"
        )
        """
      },
      %{
        id: :bar_monthly,
        title: "Bar: Monthly Sales",
        code: ~S"""
        monthly = [
          %{"month" => "Jan", "sales" => 42},
          %{"month" => "Feb", "sales" => 55},
          %{"month" => "Mar", "sales" => 61},
          %{"month" => "Apr", "sales" => 48},
          %{"month" => "May", "sales" => 73}
        ]
        Plotly.bar(monthly, x: "month", y: "sales", title: "Monthly Sales")
        """
      },
      %{
        id: :bar_grouped,
        title: "Grouped Bar: Regional Sales",
        code: ~S"""
        regional = [
          %{"quarter" => "Q1", "sales" => 120, "region" => "North"},
          %{"quarter" => "Q2", "sales" => 145, "region" => "North"},
          %{"quarter" => "Q3", "sales" => 162, "region" => "North"},
          %{"quarter" => "Q1", "sales" =>  98, "region" => "South"},
          %{"quarter" => "Q2", "sales" => 112, "region" => "South"},
          %{"quarter" => "Q3", "sales" => 130, "region" => "South"}
        ]
        Plotly.bar(regional,
          x: "quarter",
          y: "sales",
          color: "region",
          title: "Sales by Region (grouped)"
        )
        """
      },
      %{
        id: :line_temp,
        title: "Line: Temperature",
        code: ~S"""
        temps = [
          %{"month" => "Jan", "temp" =>  2.3},
          %{"month" => "Feb", "temp" =>  3.1},
          %{"month" => "Mar", "temp" =>  7.5},
          %{"month" => "Apr", "temp" => 12.8},
          %{"month" => "May", "temp" => 17.2},
          %{"month" => "Jun", "temp" => 20.9},
          %{"month" => "Jul", "temp" => 22.4},
          %{"month" => "Aug", "temp" => 21.8},
          %{"month" => "Sep", "temp" => 17.6},
          %{"month" => "Oct", "temp" => 12.1},
          %{"month" => "Nov", "temp" =>  6.7},
          %{"month" => "Dec", "temp" =>  3.2}
        ]
        Plotly.line(temps,
          x: "month",
          y: "temp",
          title: "Average Monthly Temperature (°C)"
        )
        """
      },
      %{
        id: :histogram,
        title: "Histogram: Heights",
        code: ~S"""
        heights =
          [163, 170, 175, 168, 172, 165, 178, 171, 169, 174,
           167, 176, 173, 164, 179, 170, 166, 177, 171, 173]
          |> Enum.map(&%{"height" => &1})
        Plotly.histogram(heights, x: "height", title: "Height Distribution (cm)")
        """
      },
      %{
        id: :box_scores,
        title: "Box Plot: Test Scores",
        code: ~S"""
        scores = [
          %{"group" => "A", "score" => 72}, %{"group" => "A", "score" => 85},
          %{"group" => "A", "score" => 78}, %{"group" => "A", "score" => 91},
          %{"group" => "A", "score" => 68}, %{"group" => "A", "score" => 88},
          %{"group" => "B", "score" => 55}, %{"group" => "B", "score" => 62},
          %{"group" => "B", "score" => 70}, %{"group" => "B", "score" => 58},
          %{"group" => "B", "score" => 65}, %{"group" => "B", "score" => 73},
          %{"group" => "C", "score" => 90}, %{"group" => "C", "score" => 95},
          %{"group" => "C", "score" => 88}, %{"group" => "C", "score" => 92},
          %{"group" => "C", "score" => 86}, %{"group" => "C", "score" => 97}
        ]
        Plotly.box(scores, x: "group", y: "score", title: "Test Scores by Group")
        """
      },
      %{
        id: :pie_budget,
        title: "Pie: Budget",
        code: ~S"""
        budget = [
          %{"category" => "Housing",       "amount" => 1_500},
          %{"category" => "Food",          "amount" =>   600},
          %{"category" => "Transport",     "amount" =>   350},
          %{"category" => "Entertainment", "amount" =>   200},
          %{"category" => "Savings",       "amount" =>   500},
          %{"category" => "Other",         "amount" =>   250}
        ]
        Plotly.pie(budget,
          values: "amount",
          names: "category",
          title: "Monthly Budget"
        )
        """
      },
      %{
        id: :scatter_modes,
        title: "Line + Scatter Modes",
        code: ~S"""
        alias Plotly.{Figure, Scatter}
        Figure.new()
        |> Figure.add_trace(Scatter.new(
             x: [1, 2, 3, 4], y: [10, 15, 13, 17],
             mode: "markers", name: "Scatter"))
        |> Figure.add_trace(Scatter.new(
             x: [2, 3, 4, 5], y: [16, 5, 11, 9],
             mode: "lines", name: "Lines"))
        |> Figure.add_trace(Scatter.new(
             x: [1, 2, 3, 4], y: [12, 9, 15, 12],
             mode: "lines+markers", name: "Lines+Markers"))
        |> Figure.update_layout(title: "Line and Scatter Modes")
        """
      },
      %{
        id: :heatmap,
        title: "Heatmap",
        code: ~S"""
        alias Plotly.{Figure, Heatmap}
        Figure.new()
        |> Figure.add_trace(Heatmap.new(
             z: [[1, 20, 30, 5], [20, 1, 60, 10], [30, 60, 1, 40], [5, 10, 40, 1]],
             x: ["Mon", "Tue", "Wed", "Thu"],
             y: ["Morning", "Afternoon", "Evening", "Night"],
             colorscale: "Viridis"))
        |> Figure.update_layout(title: "Activity Heatmap")
        """
      },
      %{
        id: :bubble,
        title: "Bubble Chart",
        code: ~S"""
        alias Plotly.{Figure, Scatter}
        Figure.new()
        |> Figure.add_trace(Scatter.new(
             x: [1, 2, 3, 4, 5],
             y: [10, 14, 8, 17, 12],
             mode: "markers",
             marker: %{
               size: [20, 40, 30, 60, 45],
               color: [1, 2, 3, 4, 5],
               colorscale: "Portland",
               showscale: true
             },
             text: ["Small", "Medium", "Med-Small", "Large", "Med-Large"]))
        |> Figure.update_layout(title: "Bubble Chart")
        """
      },
      %{
        id: :filled_area,
        title: "Filled Area",
        code: ~S"""
        alias Plotly.{Figure, Scatter}
        x = [1, 2, 3, 4, 5, 6, 7]
        Figure.new()
        |> Figure.add_trace(Scatter.new(
             x: x, y: [0, 1, 3, 2, 4, 3, 2],
             fill: "tozeroy", mode: "lines", name: "Series A"))
        |> Figure.add_trace(Scatter.new(
             x: x, y: [0, 2, 5, 3, 6, 5, 3],
             fill: "tonexty", mode: "lines", name: "Series B"))
        |> Figure.update_layout(title: "Filled Area Chart")
        """
      },
      %{
        id: :candlestick,
        title: "Candlestick",
        code: ~S"""
        alias Plotly.{Figure, Candlestick}
        Figure.new()
        |> Figure.add_trace(Candlestick.new(
             x: ["2024-01-01", "2024-01-02", "2024-01-03", "2024-01-04",
                 "2024-01-05", "2024-01-06", "2024-01-07", "2024-01-08"],
             open:  [100, 110, 108, 115, 112, 118, 116, 120],
             high:  [118, 125, 118, 128, 122, 130, 126, 135],
             low:   [ 98, 105, 100, 110, 104, 112, 108, 115],
             close: [110, 108, 115, 112, 118, 116, 120, 118]))
        |> Figure.update_layout(title: "Stock Price (Candlestick)")
        """
      },
      %{
        id: :surface_3d,
        title: "3D Surface",
        code: ~S"""
        alias Plotly.{Figure, Surface}
        z =
          for i <- 0..24 do
            for j <- 0..24 do
              r = :math.sqrt((i - 12.0) ** 2 + (j - 12.0) ** 2)
              :math.sin(r * 0.5)
            end
          end
        Figure.new()
        |> Figure.add_trace(Surface.new(z: z, colorscale: "Viridis"))
        |> Figure.update_layout(title: "3D Surface: sin(r)")
        """
      },
      %{
        id: :choropleth,
        title: "Choropleth Map",
        code: ~S"""
        alias Plotly.{Figure, Choropleth}
        Figure.new()
        |> Figure.add_trace(Choropleth.new(
             locations: ["CA", "TX", "FL", "NY", "IL", "PA", "OH", "GA", "NC", "MI"],
             z: [39.5, 29.1, 21.5, 19.5, 12.6, 12.8, 11.8, 10.7, 10.4, 10.0],
             locationmode: "USA-states",
             colorscale: "Blues",
             text: ["California", "Texas", "Florida", "New York", "Illinois",
                    "Pennsylvania", "Ohio", "Georgia", "North Carolina", "Michigan"],
             hovertemplate: "%{text}: %{z:.1f}M<extra></extra>"))
        |> Figure.update_layout(
             title: "US State Populations (millions)",
             geo: %{scope: "usa", projection: %{type: "albers usa"}})
        """
      },
      %{
        id: :time_series,
        title: "Time Series + Range Slider",
        code: ~S"""
        alias Plotly.{Figure, Scatter}
        dates =
          for d <- 1..60 do
            month = if d <= 31, do: "01", else: "02"
            day = rem(d - 1, 31) + 1
            "2024-#{month}-#{String.pad_leading(to_string(day), 2, "0")}"
          end
        values = Enum.with_index(dates, fn _, i ->
          :math.sin(i * 0.3) * 15 + 100 + rem(i * 13, 7)
        end)
        Figure.new()
        |> Figure.add_trace(Scatter.new(x: dates, y: values, mode: "lines", name: "Metric"))
        |> Figure.update_layout(
             title: "Time Series with Range Slider",
             xaxis: %{rangeslider: %{visible: true}, title: "Date"},
             yaxis: %{title: "Value"})
        """
      },
      %{
        id: :quiver,
        title: "Quiver: Vector Field + MathJax",
        code: ~S"""
        data = for x <- -1..1, y <- -1..1, do: %{"x" => x, "y" => y, "u" => -y, "v" => x}
        Plotly.quiver(data, x: "x", y: "y", u: "u", v: "v")
        |> Plotly.Figure.update_layout(
          title: %{text: "$\\vec{F}(x,y)=(-y,x)$"},
          xaxis: %{title: %{text: "x"}},
          yaxis: %{title: %{text: "y"}, scaleanchor: "x"})
        """
      },
      %{
        id: :click_events,
        title: "Click Events → Server",
        code: ~S"""
        alias Plotly.{Figure, Scatter}
        Figure.new()
        |> Figure.add_trace(Scatter.new(
             x: [1, 2, 3, 4, 5],
             y: [2, 4, 3, 5, 1],
             mode: "markers",
             marker: %{
               size: 20,
               color: ["#636EFA", "#EF553B", "#00CC96", "#AB63FA", "#FFA15A"]
             },
             name: "Clickable Points",
             text: ["Alpha", "Beta", "Gamma", "Delta", "Epsilon"]))
        |> Figure.update_layout(
             title: "Click a Point — Server Message Appears Here",
             xaxis: %{title: "X"},
             yaxis: %{title: "Y"},
             annotations: [
               %{
                 text: "← Click any point to see<br>the LiveView message received",
                 x: 0.01, y: 0.99,
                 xref: "paper", yref: "paper",
                 xanchor: "left", yanchor: "top",
                 showarrow: false, align: "left",
                 font: %{size: 11, color: "#64748b"},
                 bgcolor: "rgba(248, 250, 252, 0.9)",
                 bordercolor: "#cbd5e1",
                 borderwidth: 1, borderpad: 6
               }
             ])
        """
      }
    ]
  end
end

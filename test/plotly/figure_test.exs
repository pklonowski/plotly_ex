defmodule Plotly.FigureTest do
  use ExUnit.Case, async: true
  doctest Plotly.Figure

  alias Plotly.Figure

  describe "new/1" do
    test "builds a figure with defaults" do
      fig = Figure.new()
      assert fig.data == []
      assert fig.layout == %{}
      assert fig.frames == []
      assert fig.config == %{}
    end

    test "accepts known fields" do
      fig = Figure.new(data: [:placeholder], layout: %{title: "Hi"})
      assert fig.data == [:placeholder]
      assert fig.layout == %{title: "Hi"}
    end

    test "raises ArgumentError on unknown keys" do
      assert_raise ArgumentError, ~r/unknown keys/, fn ->
        Figure.new(bad_key: "value")
      end
    end
  end

  describe "add_trace/2" do
    test "appends a trace to the data list" do
      fig = Figure.new() |> Figure.add_trace(:trace_a)
      assert fig.data == [:trace_a]
    end

    test "called twice appends in order" do
      fig =
        Figure.new()
        |> Figure.add_trace(:trace_a)
        |> Figure.add_trace(:trace_b)

      assert fig.data == [:trace_a, :trace_b]
    end

    test "does not mutate the original figure" do
      original = Figure.new()
      _new = Figure.add_trace(original, :trace_a)
      assert original.data == []
    end
  end

  describe "update_layout/2" do
    test "merges new attrs into empty layout" do
      fig = Figure.new() |> Figure.update_layout(title: "Chart")
      assert fig.layout == %{title: "Chart"}
    end

    test "merges new attrs into existing layout" do
      fig =
        Figure.new(layout: %{title: "Old"})
        |> Figure.update_layout(width: 800)

      assert fig.layout == %{title: "Old", width: 800}
    end

    test "shallow-merges: overwrites nested map entirely" do
      fig =
        Figure.new(layout: %{title: %{text: "Old", font: %{size: 18}}})
        |> Figure.update_layout(title: %{text: "New"})

      # Shallow merge: title.font is gone — documented behaviour
      assert fig.layout.title == %{text: "New"}
      refute Map.has_key?(fig.layout.title, :font)
    end

    test "accepts a plain map as attrs" do
      fig = Figure.new() |> Figure.update_layout(%{title: "Chart"})
      assert fig.layout == %{title: "Chart"}
    end

    test "keyword list axis value is normalised to map" do
      fig = Figure.new() |> Figure.update_layout(xaxis: [title: "X axis"])
      assert fig.layout.xaxis == %{title: "X axis"}
    end

    test "nested keyword list in layout is fully normalised" do
      fig = Figure.new() |> Figure.update_layout(font: [family: "Arial", size: 14])
      assert fig.layout.font == %{family: "Arial", size: 14}
    end
  end

  describe "merge/2" do
    test "appends fig2 data into fig1" do
      fig1 = Figure.new(data: [:trace_a], layout: %{title: "First"})
      fig2 = Figure.new(data: [:trace_b], layout: %{title: "Second"})
      merged = Figure.merge(fig1, fig2)
      assert merged.data == [:trace_a, :trace_b]
    end

    test "preserves fig1 layout, discards fig2 layout" do
      fig1 = Figure.new(layout: %{title: "Keep"})
      fig2 = Figure.new(layout: %{title: "Discard"})
      merged = Figure.merge(fig1, fig2)
      assert merged.layout == %{title: "Keep"}
    end

    test "works when either figure has empty data" do
      fig1 = Figure.new(data: [:trace_a])
      fig2 = Figure.new()
      assert Figure.merge(fig1, fig2).data == [:trace_a]
      assert Figure.merge(fig2, fig1).data == [:trace_a]
    end

    test "does not mutate either figure" do
      fig1 = Figure.new(data: [:a])
      fig2 = Figure.new(data: [:b])
      _merged = Figure.merge(fig1, fig2)
      assert fig1.data == [:a]
      assert fig2.data == [:b]
    end
  end

  describe "to_json/1 and Jason.Encoder" do
    test "empty keyword layout and config retain their object boundary semantics" do
      figures = [Figure.new(layout: [], config: []), %Figure{layout: [], config: []}]

      for figure <- figures do
        assert Jason.decode!(Figure.to_json(figure)) == %{"layout" => %{}}
      end
    end

    test "render JSON keeps empty keyword layout an object and adds config defaults" do
      figure = Figure.new(layout: [], config: [])

      assert Jason.decode!(Figure.to_render_json(figure)) == %{
               "layout" => %{},
               "config" => %{"showSendToCloud" => false}
             }
    end

    test "Layout constructors keep empty options as an object and nested arrays as arrays" do
      assert Jason.decode!(Jason.encode!(Plotly.Layout.new([]))) == %{}

      layout = Plotly.Layout.new(annotations: [], xaxis: [tickvals: []])

      assert Jason.decode!(Jason.encode!(layout)) == %{
               "annotations" => [],
               "xaxis" => %{"tickvals" => []}
             }
    end

    test "produces valid JSON" do
      json = Figure.new() |> Figure.to_json()
      assert {:ok, _} = Jason.decode(json)
    end

    test "always includes layout key even when empty" do
      decoded = Figure.new() |> Figure.to_json() |> Jason.decode!()
      assert Map.has_key?(decoded, "layout")
    end

    test "omits data when empty" do
      decoded = Figure.new() |> Figure.to_json() |> Jason.decode!()
      refute Map.has_key?(decoded, "data")
    end

    test "omits frames when empty" do
      decoded = Figure.new() |> Figure.to_json() |> Jason.decode!()
      refute Map.has_key?(decoded, "frames")
    end

    test "omits config when empty" do
      decoded = Figure.new() |> Figure.to_json() |> Jason.decode!()
      refute Map.has_key?(decoded, "config")
    end

    test "includes data when non-empty" do
      # Use a plain map as stand-in for a real trace
      fig = Figure.new(data: [%{type: "scatter", x: [1], y: [2]}])
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert [%{"type" => "scatter"}] = decoded["data"]
    end

    test "includes config when non-empty" do
      fig = Figure.new(config: %{responsive: true})
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["config"] == %{"responsive" => true}
    end

    test "round-trips layout through JSON" do
      fig = Figure.new(layout: %{title: "Hello", width: 800})
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["layout"]["title"] == "Hello"
      assert decoded["layout"]["width"] == 800
    end

    test "layout with keyword list axis value round-trips through JSON" do
      fig = Figure.new() |> Figure.update_layout(xaxis: [title: "X"], yaxis: [title: "Y"])
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["layout"]["xaxis"]["title"] == "X"
      assert decoded["layout"]["yaxis"]["title"] == "Y"
    end

    test "keyword list config round-trips through JSON" do
      fig = Figure.new(config: [responsive: true, displayModeBar: false, scrollZoom: true])
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["config"]["responsive"] == true
      assert decoded["config"]["displayModeBar"] == false
      assert decoded["config"]["scrollZoom"] == true
    end

    test "keyword list layout passed directly to Figure.new round-trips through JSON" do
      fig = Figure.new(layout: [title: "My Chart", width: 800])
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["layout"]["title"] == "My Chart"
      assert decoded["layout"]["width"] == 800
    end

    test "3D scene axis title strings are coerced to %{text: ...} objects" do
      # plotly.js (unlike for 2D cartesian axes) does not default a bare
      # string scene.xaxis.title to %{text: ...}; it silently falls back to
      # "x"/"y"/"z" instead of rendering the given title. See notebook
      # fundamentals/50_set_axes_title.livemd.
      fig =
        Figure.new()
        |> Figure.update_layout(
          scene: %{
            xaxis: %{title: "cos(t)"},
            yaxis: %{title: "sin(t)"},
            zaxis: %{title: "t (time)"}
          }
        )

      decoded = fig |> Figure.to_json() |> Jason.decode!()

      assert decoded["layout"]["scene"]["xaxis"]["title"] == %{"text" => "cos(t)"}
      assert decoded["layout"]["scene"]["yaxis"]["title"] == %{"text" => "sin(t)"}
      assert decoded["layout"]["scene"]["zaxis"]["title"] == %{"text" => "t (time)"}
    end

    test "3D scene axis title given as a map already passes through unchanged" do
      fig =
        Figure.new()
        |> Figure.update_layout(scene: %{xaxis: %{title: %{text: "X", font: %{size: 20}}}})

      decoded = fig |> Figure.to_json() |> Jason.decode!()

      assert decoded["layout"]["scene"]["xaxis"]["title"] == %{
               "text" => "X",
               "font" => %{"size" => 20}
             }
    end

    test "secondary scene (scene2) axis title strings are coerced too" do
      fig = Figure.new() |> Figure.update_layout(scene2: %{xaxis: %{title: "cos(t)"}})
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["layout"]["scene2"]["xaxis"]["title"] == %{"text" => "cos(t)"}
    end

    test "2D cartesian axis title strings are left as bare strings" do
      fig = Figure.new() |> Figure.update_layout(xaxis: %{title: "X"}, yaxis: %{title: "Y"})
      decoded = fig |> Figure.to_json() |> Jason.decode!()
      assert decoded["layout"]["xaxis"]["title"] == "X"
      assert decoded["layout"]["yaxis"]["title"] == "Y"
    end
  end

  describe "to_render_json/1" do
    test "defaults Cloud upload off without changing faithful serialization or input" do
      fig = Figure.new()
      assert Jason.decode!(Figure.to_render_json(fig))["config"] == %{"showSendToCloud" => false}
      refute Map.has_key?(Jason.decode!(Figure.to_json(fig)), "config")
      assert fig.config == %{}
    end

    test "preserves explicit config flags and other nested options in every supported form" do
      for value <- [true, false],
          config <- [
            %{showSendToCloud: value},
            %{"showSendToCloud" => value},
            [showSendToCloud: value]
          ] do
        fig = Figure.new(config: config)
        json = Figure.to_render_json(fig)
        assert Jason.decode!(json)["config"]["showSendToCloud"] == value
        assert length(Regex.scan(~r/"showSendToCloud":/, json)) == 1
        assert fig.config == config
      end

      json =
        Figure.new(config: [toImageButtonOptions: [format: "svg"]])
        |> Figure.to_render_json()
        |> Jason.decode!()

      assert json["config"] == %{
               "showSendToCloud" => false,
               "toImageButtonOptions" => %{"format" => "svg"}
             }
    end
  end
end

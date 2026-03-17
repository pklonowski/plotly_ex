defmodule Plotly.LayoutTest do
  use ExUnit.Case, async: true

  alias Plotly.Layout

  describe "new/1" do
    test "title accepts a map with automargin and yref" do
      l = Layout.new(title: %{text: "My Title", automargin: true, yref: "paper"})
      assert l.title == %{text: "My Title", automargin: true, yref: "paper"}
    end

    test "template accepts nested map with annotationdefaults" do
      l = Layout.new(template: %{layout: %{annotationdefaults: %{font: %{size: 12}}}})
      assert l.template == %{layout: %{annotationdefaults: %{font: %{size: 12}}}}
    end

    test "xaxis tickformatstops array passes through" do
      l =
        Layout.new(
          xaxis: %{
            tickformatstops: [
              %{dtickrange: [nil, 1000], value: "%H:%M:%S.%L ms"},
              %{dtickrange: [1000, 60_000], value: "%H:%M:%S s"},
              %{dtickrange: [60_000, 3_600_000], value: "%H:%M m"},
              %{dtickrange: [3_600_000, 86_400_000], value: "%H:%M h"},
              %{dtickrange: [86_400_000, 604_800_000], value: "%e. %b d"},
              %{dtickrange: [604_800_000, "M1"], value: "%e. %b w"},
              %{dtickrange: ["M1", "M12"], value: "%b '%y M"},
              %{dtickrange: ["M12", nil], value: "%Y Y"}
            ]
          }
        )

      assert l.xaxis.tickformatstops |> length() == 8
    end

    test "shapes array with plain maps passes through" do
      l =
        Layout.new(
          shapes: [
            %{type: "rect", x0: 1, x1: 2, y0: 0, y1: 1, xref: "x", yref: "paper"},
            %{type: "circle", x0: 3, x1: 4, y0: 2, y1: 3, xref: "x", yref: "y"}
          ]
        )

      assert length(l.shapes) == 2
      assert hd(l.shapes).type == "rect"
    end

    test "scene.annotations list passes through" do
      l =
        Layout.new(
          scene: %{
            annotations: [
              %{x: 1, y: 2, z: 3, text: "Peak", showarrow: true, arrowhead: 1}
            ]
          }
        )

      assert l.scene.annotations |> length() == 1
    end

    test "scattergap is accepted" do
      l = Layout.new(scattermode: "group", scattergap: 0.7)
      assert l.scattergap == 0.7
      assert l.scattermode == "group"
    end

    test "barcornerradius is accepted" do
      l = Layout.new(barcornerradius: 15)
      assert l.barcornerradius == 15
    end

    test "shape label map passes through" do
      l =
        Layout.new(
          shapes: [
            %{
              type: "rect",
              x0: 1,
              x1: 3,
              y0: 0,
              y1: 2,
              label: %{
                text: "Region A",
                font: %{size: 14, color: "red"},
                textposition: "middle center"
              }
            }
          ]
        )

      shape = hd(l.shapes)
      assert shape.label.text == "Region A"
    end
  end
end

defmodule Plotly.DocsCoverageTest do
  use ExUnit.Case, async: true

  # Each documentation (D) row in the design's upstream checklist has a marker.
  # Paired MathJax rows share the same documentation section.
  @upstream_docs [
    {"map trace and subplot migration",
     ["Scattermap", "Choroplethmap", "Densitymap", "layout.map"]},
    {"removed Mapbox config", ["mapboxAccessToken"]},
    {"MathJax compatibility", ["MathJax 4", "MathJax 2"]},
    {"Chart Studio removals",
     ["showLink", "linkText", "sendData", "showSources", "showEditInChartStudio", "stream"]},
    {"source attribute removals", ["*src", "layout.hidesources"]},
    {"color migration", ["culori", "oklch", "WCAG", "0–1", "rgb("]},
    {"overlay ticks", ["tickmode", "sync"]},
    {"scatter matrix axes", ["splom", "matches"]},
    {"country lookup", ["country-iso-search"]},
    {"geo fitbounds", ["geo.fitbounds", "locations"]},
    {"anywhere axis values", ["xvals", "yvals", "hoveranywhere", "clickanywhere"]},
    {"geo scale bounds", ["minscale", "maxscale"]},
    {"quiver", ["quiver", "Plotly.Quiver", "u:", "v:"]},
    {"shape legends", ["Dashed shapes", "legend"]},
    {"Sankey controls", ["Sankey", "direction", "node.sort", "link.sort"]},
    {"cursor and point pixels", ["xPixel", "yPixel", "cursor", "point centre"]},
    {"unhover", ["plotly_unhover"]},
    {"map icons", ["Maki 8.2", "circle legend icons"]},
    {"download filename", ["plot title", "download filename"]},
    {"Cloud opt-in", ["showSendToCloud: true", "cloud.plotly.com"]},
    {"JSON export", ["downloadJson", "modeBarButtonsToAdd"]},
    {"legend double click", ["legend.groupdoubleclick"]},
    {"double click delay", ["500 ms"]},
    {"map rendering requirements", ["MapLibre GL v6", "WebGL2"]},
    {"rotated map selection", ["rotated", "lasso", "box selection"]},
    {"responsive resizing", ["ResizeObserver", "responsive"]}
  ]

  for {change, markers} <- @upstream_docs do
    test "README covers #{change}" do
      readme = File.read!("README.md")

      for marker <- unquote(markers) do
        assert String.contains?(String.downcase(readme), String.downcase(marker)),
               "README is missing #{inspect(marker)}"
      end
    end
  end

  test "README explains validation boundaries and migration escape hatches" do
    readme = File.read!("README.md")

    for marker <- [
          "top-level",
          "escape hatch",
          "nested",
          "plain-map traces",
          "layout",
          "config",
          "marker.opacity"
        ] do
      assert String.contains?(String.downcase(readme), String.downcase(marker)),
             "README is missing #{inspect(marker)}"
    end
  end
end

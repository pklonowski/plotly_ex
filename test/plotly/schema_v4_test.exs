defmodule Plotly.SchemaV4Test do
  use ExUnit.Case, async: true

  test "unknown map keys raise the documented ArgumentError for traces and layout" do
    for module <- [Plotly.Scatter, Plotly.Layout] do
      assert_raise ArgumentError, ~r/unknown keys \[:not_a_plotly_field\]/, fn ->
        module.new(%{not_a_plotly_field: true})
      end
    end
  end

  test "v4 removes obsolete top-level fields for keyword and map options" do
    for {module, key} <- [
          {Plotly.Scatter, :stream},
          {Plotly.Bar, :xsrc},
          {Plotly.Layout, :mapbox},
          {Plotly.Layout, :hidesources},
          {Plotly.Choroplethmap, :opacity}
        ],
        opts <- [[{key, true}], %{key => true}] do
      assert_raise ArgumentError, ~r/unknown keys \[#{inspect(key)}\]/, fn -> module.new(opts) end
    end
  end

  test "new top-level layout and sankey attributes are accepted" do
    layout = Plotly.Layout.new(hoveranywhere: true, clickanywhere: true, hoversort: "value")
    assert layout.hoveranywhere
    assert layout.clickanywhere
    assert layout.hoversort == "value"
    assert Plotly.Sankey.new(direction: "reversed").direction == "reversed"
  end

  test "new nested attributes are in the schema and survive JSON encoding" do
    schema = "priv/schema/plotly_schema.json" |> File.read!() |> Jason.decode!()

    for key <-
          ~w(layout.geo.projection.minscale layout.geo.projection.maxscale layout.legend.groupdoubleclick sankey.link.sort sankey.node.sort) do
      assert Map.has_key?(schema, key), "Missing v4 schema attribute #{key}"
    end

    layout =
      Plotly.Layout.new(
        geo: [projection: [minscale: 0.5, maxscale: 4]],
        legend: [groupdoubleclick: "toggleitem"]
      )

    encoded = Jason.decode!(Jason.encode!(layout))
    assert encoded["geo"]["projection"] == %{"minscale" => 0.5, "maxscale" => 4}
    assert encoded["legend"]["groupdoubleclick"] == "toggleitem"

    sankey =
      Plotly.Sankey.new(link: [sort: "input"], node: [sort: "input"])
      |> Jason.encode!()
      |> Jason.decode!()

    assert sankey["link"]["sort"] == "input"
    assert sankey["node"]["sort"] == "input"
  end
end

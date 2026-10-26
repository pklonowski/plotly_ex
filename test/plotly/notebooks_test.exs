defmodule Plotly.NotebooksTest do
  use ExUnit.Case, async: true

  @removed ~r/Scattermapbox|Densitymapbox|Choroplethmapbox|mapbox:|mapboxAccessToken|showLink|linkText|sendData|showEditInChartStudio|showSources/

  describe "modebar examples" do
    import Kino.Test
    setup :configure_livebook_bridge

    @tag :requires_kino
    test "the Cloud opt-in notebook creates a live chart with explicit upload config" do
      chart =
        evaluate_example(
          "notebooks/fundamentals/12_display_edit_in_chart_studio_modebar_button.livemd"
        )

      payload = chart |> connect() |> Jason.decode!()
      figure = Jason.decode!(payload["figureJson"])
      assert figure["config"]["showSendToCloud"] == true
    end

    @tag :requires_kino
    test "the download notebook creates a live chart with local JSON export" do
      chart = evaluate_example("notebooks/fundamentals/131_download_json_button.livemd")
      payload = chart |> connect() |> Jason.decode!()
      figure = Jason.decode!(payload["figureJson"])

      assert "downloadJson" in figure["config"]["modeBarButtonsToAdd"]
      assert figure["config"]["displayModeBar"] == true
      assert figure["config"]["showSendToCloud"] == false
    end
  end

  test "v4 features have runnable example notebooks" do
    required = ~w(
      maps/24_map_styles_without_tokens
      maps/28_tile_density_map
      maps/32_tile_county_choropleth_map
      maps/38_scatter_tile_map
      scientific_charts/49_quiver_basic
      scientific_charts/50_quiver_grouped_express
      scientific_charts/51_quiver_over_contour
      chart_events/13_hover_click_anywhere
      fundamentals/131_download_json_button
      fundamentals/132_css_color_formats
    )

    missing =
      required
      |> Enum.map(&Path.join("notebooks", &1 <> ".livemd"))
      |> Enum.reject(&File.exists?/1)

    assert missing == [], "missing v4 notebooks:\n" <> Enum.join(missing, "\n")
  end

  test "notebook Elixir examples parse" do
    failures =
      for {path, block, code} <- notebook_blocks(),
          not String.contains?(code, "Mix.install("),
          {:error, error} <- [Code.string_to_quoted(code)] do
        "#{path} (Elixir block #{block}): #{inspect(error)}"
      end

    assert failures == [], "invalid notebook examples:\n" <> Enum.join(failures, "\n")
  end

  test "validation includes event bodies saved with longer Livebook fences" do
    blocks = notebook_blocks()

    for path <- [
          "notebooks/chart_events/06_capturing_hover_pixels.livemd",
          "notebooks/chart_events/13_hover_click_anywhere.livemd"
        ] do
      codes = for {^path, _block, code} <- blocks, do: code

      assert Enum.any?(codes, &String.contains?(&1, "Mix.install("))

      assert Enum.any?(codes, &String.contains?(&1, "PlotlyLive.subscribe(")),
             "validator skipped the event body in #{path}"
    end
  end

  test "notebook Elixir examples do not use removed v4 traces or config" do
    failures =
      for {path, block, code} <- notebook_blocks(),
          matches = Regex.scan(@removed, code) |> List.flatten() |> Enum.uniq(),
          matches != [] do
        "#{path} (Elixir block #{block}): #{Enum.join(matches, ", ")}"
      end

    assert failures == [],
           "removed v4 attributes in notebook examples:\n" <> Enum.join(failures, "\n")
  end

  test "Choroplethmap examples put opacity inside marker" do
    failures =
      for {path, block, code} <- notebook_blocks(),
          {:ok, ast} <- [Code.string_to_quoted(code)],
          top_level_choropleth_opacity?(ast) do
        "#{path} (Elixir block #{block}): Choroplethmap.new has top-level opacity"
      end

    assert failures == [], "invalid Choroplethmap opacity:\n" <> Enum.join(failures, "\n")
  end

  defp notebook_blocks do
    paths = Path.wildcard("notebooks/**/*.livemd")
    assert paths != [], "expected notebook files to validate"

    Enum.flat_map(paths, fn path ->
      ~r/^(`{3,})elixir[^\n]*\n(.*?)^\1[ \t]*$/ms
      |> Regex.scan(File.read!(path), capture: :all_but_first)
      |> Enum.with_index(1)
      |> Enum.map(fn {[_fence, code], block} -> {path, block, code} end)
    end)
  end

  defp evaluate_example(path) do
    [code] =
      for {^path, _block, code} <- notebook_blocks(),
          not String.contains?(code, "Mix.install("),
          do: code

    {chart, _binding} = Code.eval_string(code, [], file: path)
    chart
  end

  defp top_level_choropleth_opacity?(ast) do
    {_ast, found?} =
      Macro.prewalk(ast, false, fn
        {{:., _, [{:__aliases__, _, module}, :new]}, _, [opts]} = node, found?
        when is_list(opts) ->
          invalid? =
            List.last(module) == :Choroplethmap and Keyword.keyword?(opts) and
              Keyword.has_key?(opts, :opacity)

          {node, found? or invalid?}

        node, found? ->
          {node, found?}
      end)

    found?
  end
end

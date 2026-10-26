defmodule Plotly.RelayoutNotebookTest do
  use ExUnit.Case, async: true

  import Kino.Test

  setup :configure_livebook_bridge

  for path <- [
        "notebooks/custom_controls/05_relayout_button.livemd",
        "notebooks/11_custom_controls.livemd"
      ] do
    @tag :requires_kino
    test "Reset restores the default appearance and automatic ranges in #{path}" do
      {layout, buttons} = relayout_buttons(unquote(path))
      default = buttons["Light"]
      dark = buttons["Dark"]
      reset = buttons["Reset"]

      for key <- Map.keys(dark) do
        assert Map.has_key?(default, key), "Light must undo Dark's #{key}"

        assert default[key] == layout[key]

        assert reset[key] == default[key],
               "Reset must restore #{key}: expected #{inspect(default[key])}, got #{inspect(reset[key])}"
      end

      assert reset["xaxis.autorange"] == true
      assert reset["yaxis.autorange"] == true
    end

    @tag :requires_kino
    test "Light carries a light appearance distinct from Dark in #{path}" do
      {layout, buttons} = relayout_buttons(unquote(path))

      for key <- ["paper_bgcolor", "plot_bgcolor", "font"] do
        assert Map.has_key?(buttons["Light"], key)
        assert buttons["Light"][key] != buttons["Dark"][key]
        assert buttons["Light"][key] == layout[key]
      end

      refute Enum.any?(Map.keys(buttons["Light"]), fn key ->
               String.ends_with?(key, [".range", ".autorange"])
             end)

      for key <- Map.keys(buttons["Light"]), String.contains?(key, ".") do
        parent_path = key |> String.split(".") |> Enum.drop(-1)

        assert is_map(get_in(layout, parent_path)),
               "Light cannot update #{key} through a bare string parent"
      end
    end
  end

  defp relayout_buttons(path) do
    [code] =
      ~r/^(`{3,})elixir[^\n]*\n(.*?)^\1[ \t]*$/ms
      |> Regex.scan(File.read!(path), capture: :all_but_first)
      |> Enum.map(fn [_fence, code] -> code end)
      |> Enum.filter(&String.contains?(&1, "Relayout Button Examples"))

    {chart, _binding} = Code.eval_string(code, [], file: path)
    payload = chart |> connect() |> Jason.decode!()
    figure = Jason.decode!(payload["figureJson"])
    [menu] = figure["layout"]["updatemenus"]

    buttons =
      Map.new(menu["buttons"], fn button ->
        assert button["method"] == "relayout"
        [changes] = button["args"]
        {button["label"], changes}
      end)

    {figure["layout"], buttons}
  end
end

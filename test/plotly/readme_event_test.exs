defmodule Plotly.ReadmeEventTest do
  use ExUnit.Case, async: true

  test "the README LiveView handler receives the hook's click event envelope" do
    [hook_event] =
      Regex.run(~r/hook\.pushEvent\("([^"]+)"/, File.read!("priv/static/plotly_hook.js"),
        capture: :all_but_first
      )

    handlers =
      ~r/^```elixir[^\n]*\n(.*?)^```[ \t]*$/ms
      |> Regex.scan(File.read!("README.md"), capture: :all_but_first)
      |> Enum.flat_map(fn [code] ->
        {_ast, handlers} =
          code
          |> Code.string_to_quoted!()
          |> Macro.prewalk([], fn
            {:def, _, [{:handle_event, _, [event, payload, _socket]}, _body]} = node, handlers ->
              {node, [{event, payload} | handlers]}

            node, handlers ->
              {node, handlers}
          end)

        handlers
      end)

    click_handler =
      Enum.find(handlers, fn
        {_event, {:%{}, _, fields}} -> {"type", "plotly_click"} in fields
        _ -> false
      end)

    assert {event, {:%{}, _, fields}} = click_handler
    assert event == hook_event
    assert {"type", "plotly_click"} in fields
    assert {"data", {:%{}, _, data_fields}} = List.keyfind(fields, "data", 0)
    assert List.keymember?(data_fields, "points", 0)

    assert Enum.any?(handlers, fn
             {^hook_event, {name, _, context}} when is_atom(name) and is_atom(context) -> true
             _ -> false
           end),
           "the README handler must also accept hover, unhover, relayout and selected events"
  end
end

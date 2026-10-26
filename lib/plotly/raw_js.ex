defmodule Plotly.RawJS do
  @moduledoc """
  Wraps a raw JavaScript expression string for use in Figure config values.

  When serialised via Jason, the value is emitted as a `{"__rawjs__": "expr"}`
  marker object. The Kino and Phoenix Hook widgets detect these markers and
  `eval` them in the browser before passing the config to `Plotly.newPlot`,
  so that JavaScript references (e.g. `Plotly.Icons.camera`) and function
  literals (e.g. `"function(gd) { ... }"`) work correctly.

  ## Example

      Figure.new(config: %{
        modeBarButtonsToAdd: [%{
          name: "my_button",
          icon: Plotly.RawJS.new("Plotly.Icons.camera"),
          click: Plotly.RawJS.new("function(gd) { alert(gd.id); }")
        }]
      })
  """

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @doc """
  Wrap a JavaScript expression string.

      iex> Plotly.RawJS.new("fn()").value
      "fn()"

      iex> Jason.decode!(Jason.encode!(Plotly.RawJS.new("Plotly.Icons.camera")))
      %{"__rawjs__" => "Plotly.Icons.camera"}
  """
  def new(js_string) when is_binary(js_string), do: %__MODULE__{value: js_string}
end

defimpl Jason.Encoder, for: Plotly.RawJS do
  def encode(%{value: v}, opts), do: Jason.Encode.map(%{"__rawjs__" => v}, opts)
end

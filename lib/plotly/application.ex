defmodule Plotly.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    if Code.ensure_loaded?(Kino.SmartCell) and function_exported?(Kino.SmartCell, :register, 1) do
      apply(Kino.SmartCell, :register, [Plotly.Kino.SmartCell])
    end

    children = []
    Supervisor.start_link(children, strategy: :one_for_one, name: Plotly.Supervisor)
  end
end

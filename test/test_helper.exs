ExUnit.start()

kino_tags = if Code.ensure_loaded?(Plotly.Kino.PlotlyLive), do: [:requires_kino], else: []
phoenix_tags = if Code.ensure_loaded?(Plotly.Phoenix.Component), do: [:requires_phoenix], else: []
explorer_tags = if Code.ensure_loaded?(Explorer.DataFrame), do: [:requires_explorer], else: []

ExUnit.configure(
  exclude: [:requires_kino, :requires_phoenix, :requires_explorer],
  include: kino_tags ++ phoenix_tags ++ explorer_tags
)

defmodule Plotly.Figure do
  @moduledoc """
  Core figure struct. Holds data (list of traces), layout, frames, and config.
  Serializes to the Plotly.js JSON spec via Jason.

  `Plotly.Figure` implements `Jason.Encoder`, so figures can be embedded directly
  in any `Jason.encode!/1` call or Phoenix `json/2` — no conversion needed.

  ## Building a figure step-by-step

      alias Plotly.{Figure, Scatter}

      Figure.new()
      |> Figure.add_trace(Scatter.new(x: [1, 2, 3], y: [4, 5, 6], name: "Series A"))
      |> Figure.add_trace(Scatter.new(x: [1, 2, 3], y: [6, 5, 4], name: "Series B"))
      |> Figure.update_layout(title: "Multi-Series Chart", showlegend: true)
      |> Plotly.show()

  Or use `Plotly.Express` for one-call chart building from tabular data.
  """

  defstruct data: [], layout: %{}, frames: [], config: %{}

  @type t :: %__MODULE__{
          data: list(),
          layout: map(),
          frames: list(),
          config: map()
        }

  @doc """
  Build a new Figure. Accepts any `Plotly.Figure` field as keyword opts.

  Raises `ArgumentError` on unknown keys.

  ## Examples

      # Empty figure — add traces later with add_trace/2
      Plotly.Figure.new()

      # With initial layout
      Plotly.Figure.new(layout: %{title: "Revenue", showlegend: false})

      # With pre-built data and layout
      Plotly.Figure.new(
        data: [Plotly.Scatter.new(x: [1, 2, 3], y: [4, 5, 6])],
        layout: %{title: "My Chart", width: 700}
      )

      iex> Plotly.Figure.new().data
      []

      iex> Plotly.Figure.new(layout: %{title: "Hi"}).layout
      %{title: "Hi"}

      iex> Plotly.Figure.new(bad: "key")
      ** (ArgumentError) unknown keys [:bad] for struct Plotly.Figure
  """
  @spec new(keyword()) :: t()
  def new(opts \\ []) do
    fig = struct!(__MODULE__, opts)
    Plotly.Deprecations.warn_removed_config(fig.config)
    Plotly.Deprecations.warn_removed_layout(fig.layout)
    fig
  rescue
    KeyError ->
      valid = Map.keys(%__MODULE__{}) -- [:__struct__]
      bad = Keyword.keys(List.wrap(opts)) -- valid
      raise ArgumentError, "unknown keys #{inspect(bad)} for struct #{inspect(__MODULE__)}"
  end

  @doc """
  Append a trace to the figure's data list. Returns the updated figure.

  Traces can be typed structs (e.g. `Plotly.Scatter.new/1`) or plain maps.

  ## Examples

      alias Plotly.{Figure, Scatter, Bar}

      # Typed trace structs
      Figure.new()
      |> Figure.add_trace(Scatter.new(x: [1, 2, 3], y: [4, 5, 6], name: "Series A"))
      |> Figure.add_trace(Scatter.new(x: [1, 2, 3], y: [6, 5, 4], name: "Series B"))
      |> Figure.update_layout(title: "Two Traces")
      |> Plotly.show()

      # Or with a plain map
      Figure.new()
      |> Figure.add_trace(%{type: "bar", x: ["A", "B", "C"], y: [10, 20, 15]})

      iex> Plotly.Figure.new() |> Plotly.Figure.add_trace(:my_trace) |> Map.get(:data)
      [:my_trace]
  """
  @spec add_trace(t(), any()) :: t()
  def add_trace(%__MODULE__{} = fig, trace),
    do: %{fig | data: fig.data ++ [trace]}

  @doc """
  Combine two figures by appending `fig2`'s traces into `fig1`. `fig1`'s layout is preserved.

  Useful for overlaying charts built by separate Express calls.

  ## Examples

      # Overlay a line and a bar chart on the same axes
      price_line = Plotly.scatter(stock_data, x: "date", y: "close")
      volume_bars = Plotly.bar(stock_data, x: "date", y: "volume")

      Plotly.Figure.merge(price_line, volume_bars)
      |> Plotly.Figure.update_layout(title: "Price + Volume")
      |> Plotly.show()

      iex> fig1 = Plotly.Figure.new(data: [:a]); :ok
      :ok
      iex> Plotly.Figure.merge(fig1, Plotly.Figure.new(data: [:b])).data
      [:a, :b]
  """
  @spec merge(t(), t()) :: t()
  def merge(%__MODULE__{} = fig1, %__MODULE__{} = fig2) do
    %{fig1 | data: fig1.data ++ fig2.data}
  end

  @doc """
  Shallow-merge `attrs` into the layout map. Returns the updated figure.

  `attrs` can be a keyword list or a map. Keys are merged with `Map.merge/2` —
  **nested maps are replaced entirely, not deep-merged.**

  ## Examples

      Plotly.Figure.new()
      |> Plotly.Figure.update_layout(
        title: "Monthly Sales",
        showlegend: true,
        xaxis: %{title: "Month"},
        yaxis: %{title: "Revenue ($)"}
      )

      # Multiple calls each merge with the previous state
      figure
      |> Plotly.Figure.update_layout(title: "Chart")
      |> Plotly.Figure.update_layout(width: 700, height: 400)

      iex> Plotly.Figure.new() |> Plotly.Figure.update_layout(title: "Chart") |> Map.get(:layout)
      %{title: "Chart"}
  """
  @spec update_layout(t(), keyword() | map()) :: t()
  def update_layout(%__MODULE__{} = fig, attrs) when is_list(attrs) or is_map(attrs) do
    Plotly.Deprecations.warn_removed_layout(attrs)
    normalized = attrs |> Map.new() |> Plotly.Normalize.deep_normalize()
    %{fig | layout: Map.merge(fig.layout, normalized)}
  end

  @doc """
  Serialize the figure as stored, preserving named template references.

  Use `to_render_json/1` for browser-ready template expansion and render defaults.

  `Plotly.Figure` implements `Jason.Encoder` so figures can also be embedded
  directly in any `Jason.encode!/1` call or `conn |> json(...)` in Phoenix —
  use this function only when you need the raw string explicitly.

  ## Examples

      json =
        Plotly.Figure.new()
        |> Plotly.Figure.add_trace(Plotly.Scatter.new(x: [1, 2, 3], y: [4, 5, 6]))
        |> Plotly.Figure.to_json()

      # Pass to a Phoenix controller
      conn |> json(%{figure: json})

      # Push via Phoenix LiveView
      push_event(socket, "update_chart", %{figure: json})

      iex> json = Plotly.Figure.new() |> Plotly.Figure.to_json(); :ok
      :ok
      iex> {:ok, decoded} = Jason.decode(json); Map.has_key?(decoded, "layout")
      true
  """
  @spec to_json(t()) :: String.t()
  def to_json(%__MODULE__{} = fig), do: Jason.encode!(fig)

  @doc """
  Serialize a figure for rendering, with Plotly Cloud upload disabled by default.

  An explicit `showSendToCloud` config key (atom or string) is preserved.
  Named templates are expanded into bundled defaults for every renderer;
  `+` combines names; unknown names log a warning and render without that
  template (see `Plotly.Templates`). Inline template maps are preserved.
  This does not modify the figure or change the faithful `to_json/1` encoding.
  """
  @spec to_render_json(t()) :: String.t()
  def to_render_json(%__MODULE__{} = fig) do
    config = Map.new(fig.config)

    config =
      if Map.has_key?(config, :showSendToCloud) or Map.has_key?(config, "showSendToCloud") do
        config
      else
        Map.put(config, :showSendToCloud, false)
      end

    to_json(%{fig | config: config, layout: Plotly.Templates.resolve_layout(fig.layout)})
  end
end

defimpl Jason.Encoder, for: Plotly.Figure do
  def encode(fig, opts) do
    # layout is always emitted. data/frames/config are omitted when empty.
    layout = fig.layout |> normalize_object() |> Plotly.Normalize.coerce_scene_axis_titles()

    %{layout: layout}
    |> maybe_add(:data, fig.data, [])
    |> maybe_add(:frames, fig.frames, [])
    |> maybe_add(:config, normalize_object(fig.config), %{})
    |> Jason.Encode.map(opts)
  end

  # These roots are objects even when callers supply empty keyword options.
  # Nested empty lists remain arrays.
  defp normalize_object(value) when is_list(value),
    do: value |> Map.new() |> Plotly.Normalize.deep_normalize()

  defp normalize_object(value), do: Plotly.Normalize.deep_normalize(value)

  defp maybe_add(map, _key, val, same) when val == same, do: map
  defp maybe_add(map, key, val, _same), do: Map.put(map, key, val)
end

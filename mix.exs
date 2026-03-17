defmodule Plotly.MixProject do
  use Mix.Project

  def project do
    [
      app: :plotly_ex,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Interactive Plotly charts for Livebook and Phoenix/LiveView",
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      mod: {Plotly.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:jason, "~> 1.4"},
      {:kino, "~> 0.14", optional: true},
      {:explorer, "~> 0.11", optional: true},
      {:phoenix_live_view, "~> 1.0", optional: true},
      {:phoenix, "~> 1.7", optional: true}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE",
        "notebooks/01_express.livemd",
        "notebooks/02_builder.livemd",
        {"notebooks/03a_fundamentals_config.livemd",
         [title: "Fundamentals: Configuration & Display"]},
        {"notebooks/03b_fundamentals_styling.livemd",
         [title: "Fundamentals: Colors, Axes & Hover"]},
        {"notebooks/03c_fundamentals_shapes.livemd",
         [title: "Fundamentals: Shapes & Annotations"]},
        "notebooks/04_basic_charts.livemd",
        "notebooks/05_statistical.livemd",
        "notebooks/06_scientific.livemd",
        "notebooks/07_financial.livemd",
        "notebooks/08_maps.livemd",
        "notebooks/09_3d.livemd",
        "notebooks/10_subplots.livemd",
        "notebooks/11_custom_controls.livemd",
        "notebooks/12_animations.livemd",
        "notebooks/13_chart_events.livemd",
        "notebooks/14_kino_smart_cell.livemd"
      ],
      groups_for_extras: [
        Guides: ["notebooks/01_express.livemd", "notebooks/02_builder.livemd"],
        Fundamentals: ~r/notebooks\/03[abc]/,
        "Chart Types": ~r/notebooks\/(0[4-9]|1[0-3])/,
        SmartCell: ["notebooks/14_kino_smart_cell.livemd"]
      ],
      groups_for_modules: [
        Core: [
          Plotly,
          Plotly.Figure,
          Plotly.Express,
          Plotly.Layout,
          Plotly.RawJS,
          Plotly.Normalize
        ],
        "Kino (Livebook)": [
          Plotly.Kino.PlotlyLive,
          Plotly.Kino.PlotlyStatic,
          Plotly.Kino.SmartCell
        ],
        Phoenix: [Plotly.Phoenix.Component],
        Traces: ~r/^Plotly\.[A-Z]/
      ],
      filter_modules: fn mod, _ ->
        not String.starts_with?(to_string(mod), "Elixir.Mix.Tasks.Plotly")
      end,
      source_url: "https://github.com/pklonowski/plotly_ex",
      homepage_url: "https://hexdocs.pm/plotly_ex"
    ]
  end

  defp package do
    [
      name: "plotly_ex",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pklonowski/plotly_ex"},
      files:
        ~w(lib/plotly lib/plotly.ex priv/static notebooks mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end
end

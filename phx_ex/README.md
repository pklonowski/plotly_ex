# phx_ex

A demo Phoenix application showcasing `plotly_ex` integration with Phoenix LiveView and traditional controllers.

## Purpose

This app demonstrates how to use `plotly_ex` in a real Phoenix project — both with LiveView (reactive charts) and with regular controller/template rendering (static charts).

## Routes

| Route | Description |
|---|---|
| `GET /` | LiveView demo — reactive `Plotly.Phoenix.Component` charts that update on server push |
| `GET /static` | Controller demo — `Plotly.Phoenix.Component.static_plot/2` rendering a chart via a regular HTML response |

## Running locally

```bash
mix setup       # install deps
mix phx.server  # start on http://localhost:4000
```

## Relationship to plotly_ex

`phx_ex` lives inside the `plotly_ex` repository under `phx_ex/` and depends on the parent library via a path dependency:

```elixir
{:plotly_ex, path: ".."}
```

It is not published to Hex and is excluded from the `plotly_ex` package tarball.

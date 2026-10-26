defmodule PhxExWeb.Router do
  use PhxExWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhxExWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward "/plotly_ex", Plotly.Phoenix.Plug

  scope "/", PhxExWeb do
    pipe_through :browser

    live "/", PlotsLive, :index
    get "/static", StaticPlotController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhxExWeb do
  #   pipe_through :api
  # end
end

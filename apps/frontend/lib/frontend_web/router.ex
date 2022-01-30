defmodule FrontendWeb.Router do
  use FrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrontendWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", FrontendWeb do
    pipe_through :browser

    live "/", Live.Game
  end
end

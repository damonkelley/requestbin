defmodule RequestBin.Router do
  use RequestBin.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RequestBin do
    pipe_through :browser # Use the default browser stack

    get "/", BinController, :index
    post "/", BinController, :create

    head "/:name", BinController, :show
    connect "/:name", BinController, :show
    trace "/:name", BinController, :show
    get "/:name", BinController, :show
    post "/:name", BinController, :show
    put "/:name", BinController, :show
    patch "/:name", BinController, :show
    delete "/:name", BinController, :show
    options "/:name", BinController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", RequestBin do
  #   pipe_through :api
  # end
end

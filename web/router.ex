defmodule FourOhFourFinderApp.Router do
  use FourOhFourFinderApp.Web, :router
  use Raygun.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FourOhFourFinderApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", FourOhFourFinderApp do
    pipe_through :api
    post "/page/fetch", Api.PageController, :fetch
  end
end

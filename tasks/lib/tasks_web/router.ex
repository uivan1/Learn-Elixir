defmodule TasksWeb.Router do
  use TasksWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  scope "/api", TasksWeb do
    pipe_through :api
  end

  scope "/task", TasksWeb do
    pipe_through [:api]
    options "/", TaskController, :nothing
    options "/:id", TaskController, :nothing

    get "/", TaskController, :list
    post "/", TaskController, :create
    patch "/:id", TaskController, :update
  end


  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TasksWeb.Telemetry
    end
  end
end

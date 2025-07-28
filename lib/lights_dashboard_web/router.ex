defmodule LightsDashboardWeb.Router do
  use LightsDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LightsDashboardWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LightsDashboardWeb do
    pipe_through :browser
    get "/", LightController, :dashboard
  end

  scope "/dashboard", LightsDashboardWeb do
    pipe_through :browser

    live "/", LightLive.Index, :index
    live "/new", LightLive.Index, :new
    live "/:id/edit", LightLive.Index, :edit
    live "/:id", LightLive.Show, :show
    live "/:id/show/edit", LightLive.Show, :edit
  end

  scope "/api", LightsDashboardWeb do
    pipe_through :api
    resources "/", LightController, only: [:create, :show, :index, :update, :delete]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lights_dashboard, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LightsDashboardWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

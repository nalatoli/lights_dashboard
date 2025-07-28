defmodule LightsDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LightsDashboardWeb.Telemetry,
      LightsDashboard.Repo,
      {DNSCluster, query: Application.get_env(:lights_dashboard, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LightsDashboard.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LightsDashboard.Finch},
      # Start a worker by calling: LightsDashboard.Worker.start_link(arg)
      # {LightsDashboard.Worker, arg},
      # Start to serve requests, typically the last entry
      LightsDashboardWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LightsDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LightsDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

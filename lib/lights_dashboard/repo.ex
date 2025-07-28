defmodule LightsDashboard.Repo do
  use Ecto.Repo,
    otp_app: :lights_dashboard,
    adapter: Ecto.Adapters.Postgres
end

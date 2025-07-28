import Config

if System.get_env("PHX_SERVER") do
  config :lights_dashboard, LightsDashboardWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      DATABASE_URL is missing.
      Format: ecto://USER:PASS@HOST/DATABASE
      """

  config :lights_dashboard, LightsDashboard.Repo,
    url: database_url,
    # Set to "true" to require TLS to the database
    ssl: System.get_env("DB_SSL") in ~w(true 1),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    # Enable IPv6 if the host (e.g. Fly.io) resolves AAAA records
    socket_options: if(System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: [])

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE is missing. Generate with: mix phx.gen.secret"

  host = System.get_env("PHX_HOST") || "lights.example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :lights_dashboard, LightsDashboardWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base
end

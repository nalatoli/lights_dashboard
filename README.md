# 💡 Lights Dashboard

**lights_dashboard** is a Phoenix 1.7 LiveView application for managing IP-addressable lights across a network. It provides a real-time web interface to list, create, edit, and delete lights—each storing a name, MAC address, and ON/OFF state—using LiveView’s LiveStreams for instant UI updates.


## Features

- **Real-time updates** using Phoenix LiveView and LiveStreams.
- **CRUD operations** for lights:
  - List all lights
  - Create new lights
  - Edit existing lights
  - Delete lights
- **Modal forms** for create and edit actions.
- **Responsive UI** built with Tailwind CSS.

## Project Structure

- `assets` — Tailwind default assets:
- `lib/lights_dashboard_web/live/` — LiveViews and components:
  - `LightLive.Index` — Index page for listing lights.
  - `LightLive.Show` — Show page for individual light.
  - `LightLive.FormComponent` — LiveComponent for forms.
- `lib/lights_dashboard/lights/` — Context for Lights:
  - `lights.ex` — Business logic and function definitions.
  - `light.ex` — Ecto schema for `lights` table.
- `test/` — Tests for contexts and LiveViews.

## Requirements

- Elixir `~> 1.13`
- Erlang/OTP `~> 24`
- phoenix `~> 1.7.0`
- PostgreSQL `~> 17`

## Environment Variables

LightsDashboard follows a 12‑factor approach; secrets and deploy‑specific values are read at runtime. Create a `.env` (or export the variables in your shell / CI) *before* starting the server.

| Variable            | Example                                    | Purpose                                                       |
| ------------------- | ------------------------------------------ | ------------------------------------------------------------- |
| `DATABASE_URL`      | `ecto://user:pass@db.internal/lights_prod` | Connection string for the Repo (username, password, host, DB) |
| `SECRET_KEY_BASE`   | *(output of **`mix phx.gen.secret`**)*     | Used to sign/encrypt cookies & sessions                       |
| `PHX_HOST`          | `lights.example.com`                       | External hostname for URL generation                          |
| `PORT`              | `8080`                                     | Port the HTTP server binds to                                 |
| `POOL_SIZE`         | `15`                                       | DB connection pool size                                       |
| `DB_SSL`            | `true` / `false`                           | Enable TLS to the database                                    |
| `ECTO_IPV6`         | `true` / `false`                           | Use IPv6 sockets for DB connections                           |
| `DNS_CLUSTER_QUERY` | `lights-dashboard.internal` (optional)     | DNS name for distributed Erlang clustering                    |

## Setup (Development)

1. **Clone the repository**
   ```bash
   git clone https://github.com/nalatoli/lights_dashboard.git
   cd lights_dashboard
   ```

2. **Install dependencies**
   ```bash
    mix setup
   ```

3. **Configure the database**
   Update `config/dev.exs` with your database credentials:
   ```elixir
   config :lights_dashboard, LightsDashboard.Repo,
     username: "postgres",
     password: "postgres",
     database: "lights_dev",
     hostname: "localhost",
     show_sensitive_data_on_connection_error: true,
     pool_size: 10
   ```

4. **Create and migrate the database**
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

## Running the Server

Start the Phoenix server:
```bash
mix phx.server
```
Then visit [`http://localhost:4000/dashboard`](http://localhost:4000/dashboard) to access the LightsDashboard ([`http://localhost:4000`](http://localhost:4000/dashboard) redirects to the dashboard).

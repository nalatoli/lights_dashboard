defmodule LightsDashboardWeb.LightController do
  use LightsDashboardWeb, :controller

  alias LightsDashboard.Lights
  alias LightsDashboard.Lights.Light

  action_fallback LightsDashboardWeb.FallbackController

  def index(conn, _params) do
    lights = Lights.list_lights()
    render(conn, :index, lights: lights)
  end

  def create(conn, %{"light" => light_params}) do
    with {:ok, %Light{} = light} <- Lights.upsert_light(light_params) do
      LightsDashboardWeb.Endpoint.broadcast!("lights", "light_created", light)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/#{light}")
      |> render(:show, light: light)
    end
  end

  def show(conn, %{"id" => id}) do
    light = Lights.get_light!(id)
    render(conn, :show, light: light)
  end

  def update(conn, %{"id" => id, "light" => light_params}) do
    light = Lights.get_light!(id)

    with {:ok, %Light{} = light} <- Lights.update_light(light, light_params) do
      LightsDashboardWeb.Endpoint.broadcast!("lights", "light_updated", light)
      render(conn, :show, light: light)
    end
  end

  def delete(conn, %{"id" => id}) do
    light = Lights.get_light!(id)

    with {:ok, %Light{}} <- Lights.delete_light(light) do
      send_resp(conn, :no_content, "")
    end
  end
end

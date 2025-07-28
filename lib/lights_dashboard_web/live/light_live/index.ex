defmodule LightsDashboardWeb.LightLive.Index do
  use LightsDashboardWeb, :live_view

  alias LightsDashboard.Lights
  alias LightsDashboard.Lights.Light
  alias LightsDashboardWeb.LightLive.FormComponent

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: LightsDashboardWeb.Endpoint.subscribe("lights")
    {:ok, stream(socket, :lights, Lights.list_lights())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Light")
    |> assign(:light, Lights.get_light!(id))
    |> assign(:patch, ~p"/dashboard")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Light")
    |> assign(:light, %Light{})
    |> assign(:patch, ~p"/dashboard")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lights Dashboard")
    |> assign(:light, nil)
    |> assign(:patch, ~p"/dashboard")
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{event: event, payload: light},
        socket
      )
      when event in ["light_created", "light_updated"] do
    {:noreply, stream_insert(socket, :lights, light)}
  end

  @impl true
  def handle_info({FormComponent, {:saved, light}}, socket) do
    {:noreply, stream_insert(socket, :lights, light)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    light = Lights.get_light!(id)
    {:ok, _} = Lights.delete_light(light)

    {:noreply, stream_delete(socket, :lights, light)}
  end
end

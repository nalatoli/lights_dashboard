defmodule LightsDashboardWeb.LightLive.Show do
  use LightsDashboardWeb, :live_view

  alias LightsDashboard.Lights
  alias LightsDashboardWeb.LightLive.FormComponent

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: LightsDashboardWeb.Endpoint.subscribe("lights")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    light = Lights.get_light!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:light, light)
     |> assign(:patch, ~p"/dashboard/#{light.id}")}
  end

  @impl true
  def handle_info({FormComponent, {:saved, light}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Light updated successfully")
     |> assign(:light, light)
     |> push_patch(to: socket.assigns.patch)}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: e, payload: light}, socket)
      when e in ["light_created", "light_updated"] do
    {:noreply, stream_insert(socket, :lights, light)}
  end

  defp page_title(:show), do: "Show Light"
  defp page_title(:edit), do: "Edit Light"
end

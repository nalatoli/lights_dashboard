defmodule LightsDashboardWeb.LightLive.FormComponent do
  use LightsDashboardWeb, :live_component

  alias LightsDashboard.Lights

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage light records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="light-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:mac_address]} type="text" label="Mac address" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:state]} type="checkbox" label="State" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Light</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{light: light} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Lights.change_light(light))
     end)}
  end

  @impl true
  def handle_event("validate", %{"light" => light_params}, socket) do
    changeset = Lights.change_light(socket.assigns.light, light_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"light" => light_params}, socket) do
    save_light(socket, socket.assigns.action, light_params)
  end

  defp save_light(socket, :edit, light_params) do
    case Lights.update_light(socket.assigns.light, light_params) do
      {:ok, light} ->
        notify_parent({:saved, light})

        {:noreply,
         socket
         |> put_flash(:info, "Light updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_light(socket, :new, light_params) do
    case Lights.create_light(light_params) do
      {:ok, light} ->
        notify_parent({:saved, light})

        {:noreply,
         socket
         |> put_flash(:info, "Light created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

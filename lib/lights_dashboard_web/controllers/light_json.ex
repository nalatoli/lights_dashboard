defmodule LightsDashboardWeb.LightJSON do
  alias LightsDashboard.Lights.Light

  @doc """
  Renders a list of lights.
  """
  def index(%{lights: lights}) do
    %{data: for(light <- lights, do: data(light))}
  end

  @doc """
  Renders a single light.
  """
  def show(%{light: light}) do
    %{data: data(light)}
  end

  defp data(%Light{} = light) do
    %{
      id: light.id,
      mac_address: light.mac_address,
      name: light.name,
      state: light.state
    }
  end
end

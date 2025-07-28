defmodule LightsDashboard.LightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LightsDashboard.Lights` context.
  """

  @doc """
  Generate a unique light mac_address.
  """
  def unique_light_mac_address, do: "some mac_address#{System.unique_integer([:positive])}"

  @doc """
  Generate a light.
  """
  def light_fixture(attrs \\ %{}) do
    {:ok, light} =
      attrs
      |> Enum.into(%{
        mac_address: unique_light_mac_address(),
        name: "some name",
        state: true
      })
      |> LightsDashboard.Lights.create_light()

    light
  end
end

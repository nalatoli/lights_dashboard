defmodule LightsDashboard.Lights do
  @moduledoc """
  The Lights context.
  """

  import Ecto.Query, warn: false
  alias LightsDashboard.Repo

  alias LightsDashboard.Lights.Light

  @doc """
  Returns the list of lights.

  ## Examples

      iex> list_lights()
      [%Light{}, ...]

  """
  def list_lights do
    Repo.all(Light)
  end

  @doc """
  Gets a single light.

  Raises `Ecto.NoResultsError` if the Light does not exist.

  ## Examples

      iex> get_light!(123)
      %Light{}

      iex> get_light!(456)
      ** (Ecto.NoResultsError)

  """
  def get_light!(id), do: Repo.get!(Light, id)

  @doc """
  Creates a light.

  ## Examples

      iex> create_light(%{field: value})
      {:ok, %Light{}}

      iex> create_light(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_light(attrs \\ %{}) do
    %Light{}
    |> Light.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a light.

  ## Examples

      iex> update_light(light, %{field: new_value})
      {:ok, %Light{}}

      iex> update_light(light, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_light(%Light{} = light, attrs) do
    light
    |> Light.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Inserts a new light or updates the existing one matching `mac_address`.

    ## Examples

      iex> upsert_light(%{field: value})
      {:ok, %Light{}}

      iex> upsert_light(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_light(attrs) do
    attrs =
      Map.put(
        attrs,
        "updated_at",
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)
      )

    %Light{}
    |> Light.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: :mac_address
    )
  end

  @doc """
  Deletes a light.

  ## Examples

      iex> delete_light(light)
      {:ok, %Light{}}

      iex> delete_light(light)
      {:error, %Ecto.Changeset{}}

  """
  def delete_light(%Light{} = light) do
    Repo.delete(light)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking light changes.

  ## Examples

      iex> change_light(light)
      %Ecto.Changeset{data: %Light{}}

  """
  def change_light(%Light{} = light, attrs \\ %{}) do
    Light.changeset(light, attrs)
  end
end

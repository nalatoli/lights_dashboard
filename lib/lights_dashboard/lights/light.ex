defmodule LightsDashboard.Lights.Light do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lights" do
    field :name, :string
    field :state, :boolean, default: false
    field :mac_address, :string

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(light, attrs) do
    light
    |> cast(attrs, [:mac_address, :name, :state])
    |> validate_required([:mac_address, :name, :state])
    |> unique_constraint(:mac_address)
  end
end

defmodule LightsDashboard.Repo.Migrations.CreateLights do
  use Ecto.Migration

  def change do
    create table(:lights) do
      add :mac_address, :string
      add :name, :string
      add :state, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:lights, [:mac_address])
  end
end

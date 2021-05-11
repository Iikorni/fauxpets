defmodule Fauxpets.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories) do
      add :box_id, references(:boxes)
    end
  end
end

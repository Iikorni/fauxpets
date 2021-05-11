defmodule Fauxpets.Repo.Migrations.CreateBoxes do
  use Ecto.Migration

  def change do
    create table(:boxes) do
      add :name, :string, default: "Inventory"
      add :user_id, references(:users)
      add :inventory_no, :integer
    end
  end
end

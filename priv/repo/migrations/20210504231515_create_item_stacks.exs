defmodule Fauxpets.Repo.Migrations.CreateItemStacks do
  use Ecto.Migration

  def change do
    create table(:item_stacks) do
      add :item_id, references(:items)
      add :inventory_id, references(:inventories)
      add :slot_index, :integer
      add :quantity, :integer, default: 1
    end
  end
end

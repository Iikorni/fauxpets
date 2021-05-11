defmodule Fauxpets.Inventory do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  schema "inventories" do
    belongs_to :box, Fauxpets.Box
    has_many :stacks, Fauxpets.ItemStack
  end

  def changeset(inventory, params \\ %{}) do
    inventory
    |> Ecto.Changeset.cast(params, [])
  end
end

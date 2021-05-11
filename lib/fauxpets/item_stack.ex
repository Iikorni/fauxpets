defmodule Fauxpets.ItemStack do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  schema "item_stacks" do
    belongs_to :item, Fauxpets.Item
    belongs_to :inventory, Fauxpets.Inventory
    field :slot_index, :integer
    field :quantity, :integer, default: 1
  end

  def changeset(box, params \\ %{}) do
    box
    |> Ecto.Changeset.cast(params, [:quantity])
  end
end

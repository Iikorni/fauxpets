defmodule Fauxpets.Box do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  schema "boxes" do
    field :name, :string, default: "Inventory"
    field :inventory_no, :integer

    belongs_to :user, Fauxpets.User
    has_one :inventory, Fauxpets.Inventory
    has_one :giftbox, Fauxpets.Giftbox
  end

  def changeset(box, params \\ %{}) do
    box
    |> Ecto.Changeset.cast(params, [:name])
  end
end

defmodule Fauxpets.Gift do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  schema "gifts" do
    belongs_to(:item, Fauxpets.Item)
    belongs_to(:giftbox, Fauxpets.Giftbox)
    field(:slot_index, :integer)
    field(:item_quantity, :integer, default: 1)
    field(:is_return, :boolean, default: false)
    field(:cash_on_delivery, :boolean, default: false)
    field(:gold, :integer, default: 0)
    field(:pink, :integer, default: 0)
    field(:green, :integer, default: 0)
    belongs_to(:sender, Fauxpets.User)
    field(:send_message, :string, default: "Here's a gift for you!")
    field(:send_time, :utc_datetime)
  end

  def changeset(gift, params \\ %{}) do
    gift
    |> Ecto.Changeset.cast(params, [
      :slot_index,
      :item_quantity,
      :is_return,
      :cash_on_delivery,
      :gold,
      :pink,
      :green,
      :send_message,
      :send_time
    ])
  end
end

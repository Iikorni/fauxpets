defmodule Fauxpets.Repo.Migrations.CreateGifts do
  use Ecto.Migration

  def change do
    create table(:gifts) do
      add :item_id, references(:items)
      add :giftbox_id, references(:giftboxes)
      add :slot_index, :integer
      add :item_quantity, :integer, default: 1
      add :is_return, :boolean, default: false
      add :cash_on_delivery, :boolean, default: false
      add :gold, :integer, default: 0
      add :pink, :integer, default: 0
      add :green, :integer, default: 0
      add :sender_id, references(:users)
      add :send_message, :string, default: "Here's a gift for you!"
      add :send_time, :utc_datetime
    end
  end
end

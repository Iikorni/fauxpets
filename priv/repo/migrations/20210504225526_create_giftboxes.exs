defmodule Fauxpets.Repo.Migrations.CreateGiftboxes do
  use Ecto.Migration

  def change do
    create table(:giftboxes) do
      add :box_id, references(:boxes)
    end
  end
end

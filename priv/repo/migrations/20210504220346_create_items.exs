defmodule Fauxpets.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :reaction, :string, default: "none"
      add :goods_type, :string, default: "notattach"
      add :what_type, :string, default: "none"
      add :gold, :integer, default: 0
      add :pink, :integer, default: 0
      add :green, :integer, default: 0
      add :prize, :integer, default: 0
      add :use_level, :integer, default: 1
      add :physical, :integer, default: 0
      add :energy, :integer, default: 0
      add :karma, :integer, default: 0
      add :buff_time, :integer, default: 0
    end
  end
end

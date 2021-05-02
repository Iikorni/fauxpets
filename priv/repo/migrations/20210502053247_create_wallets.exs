defmodule Fauxpets.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :gold, :integer, default: 0
      add :pink, :integer, default: 0
      add :green, :integer, default: 0
      add :prize, :integer, default: 0
      add :user_id, references(:users)
    end
  end
end

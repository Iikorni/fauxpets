defmodule Fauxpets.Wallet do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  schema "wallets" do
    field :gold, :integer, default: 0
    field :pink, :integer, default: 0
    field :green, :integer, default: 0
    field :prize, :integer, default: 0

    belongs_to :user, Fauxpets.User
  end

  def changeset(wallet, params \\ %{}) do
    wallet
    |> Ecto.Changeset.cast(params, [:gold, :pink, :green, :prize])
  end
end

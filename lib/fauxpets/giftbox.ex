defmodule Fauxpets.Giftbox do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  schema "giftboxes" do
    belongs_to :box, Fauxpets.Box
    has_many :gifts, Fauxpets.Gift
  end

  def changeset(giftbox, params \\ %{}) do
    giftbox
    |> Ecto.Changeset.cast(params, [])
  end
end

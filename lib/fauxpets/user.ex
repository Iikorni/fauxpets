defmodule Fauxpets.User do
  use Ecto.Schema
  require Logger
  import Ecto.Query

  schema "users" do
    field(:username, :string)
    field(:password_hash, :string)
    field(:email, :string)

    has_one(:wallet, Fauxpets.Wallet)
    has_many(:boxes, Fauxpets.Box)
  end

  def changeset(user, params \\ %{}) do
    user
    |> Ecto.Changeset.cast(params, [:username, :password_hash, :email])
    |> Ecto.Changeset.validate_required([:username, :password_hash, :email])
  end

  def get_user(username) do
    Fauxpets.Repo.one(
      from(user in Fauxpets.User,
        where: user.username == ^username,
        preload: [:wallet, boxes: [inventory: [stacks: :item], giftbox: [gifts: :item]]]
      )
    )
  end

  def attempt_login(username, password_hash) do
    user = get_user(username)

    case user do
      nil ->
        Logger.error("Couldn't find user '#{username}'")
        {:error, :bad_account}

      user ->
        Logger.info("Found user '#{username}', checking hash...")

        if user.password_hash == password_hash do
          {:ok, user}
        else
          {:error, :bad_password}
        end
    end
  end
end

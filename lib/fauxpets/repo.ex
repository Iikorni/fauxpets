defmodule Fauxpets.Repo do
  use Ecto.Repo,
    otp_app: :fauxpets,
    adapter: Ecto.Adapters.Postgres
end

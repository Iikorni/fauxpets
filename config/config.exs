import Config

config :fauxpets_model, Fauxpets.Repo,
  database: "fauxpets",
  username: "postgres",
  password: "super",
  hostname: "localhost"

config :fauxpets,
  ecto_repos: [Fauxpets.Repo],
  salt: "SALT"


config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :logger,
  level: :info

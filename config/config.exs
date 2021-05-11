import Config

config :fauxpets, Fauxpets.Repo,
  database: "fauxpets",
  username: "postgres",
  password: "super",
  hostname: "localhost"

config :fauxpets,
  ecto_repos: [Fauxpets.Repo]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :logger,
  level: :info

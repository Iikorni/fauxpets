import Config

config :fauxpets, Fauxpets.Repo,
  database: "fauxpets",
  username: "postgres",
  password: "super",
  hostname: "localhost"

config :fauxpets,
  ecto_repos: [Fauxpets.Repo]

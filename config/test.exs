import Config

config :ex_cldr_trans, Cldr.Trans.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "postgres",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false

config :ex_cldr,
  default_backend: MyApp.Cldr

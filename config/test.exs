import Config

config :ex_cldr_trans, Cldr.Trans.Repo,
  username: "kip",
  database: "trans_test",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false

config :ex_cldr,
  default_backend: MyApp.Cldr

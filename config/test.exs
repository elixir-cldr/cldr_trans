use Mix.Config

config :ex_cldr_trans, Cldr.Trans.Repo,
  database: "trans_test",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false

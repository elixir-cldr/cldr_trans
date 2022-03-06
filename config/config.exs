import Config

if File.exists?("config/#{Mix.env()}.exs") do
  import_config("#{Mix.env()}.exs")
end

config :ex_cldr_trans, ecto_repos: [Cldr.Trans.Repo]

defmodule Cldr.Trans.Magazine do
  use Ecto.Schema
  use MyApp.Cldr.Trans, translates: [:title, :body]

  schema "articles" do
    field :title, :string
    field :body, :string
    translations :translations, Translations, [:es, :it, :de]
  end
end

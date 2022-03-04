defmodule Cldr.Trans.Pamphlet do
  use Ecto.Schema
  use MyApp.Cldr.Trans, translates: [:title, :body]

  schema "magazine" do
    field :title, :string
    field :body, :string
    translations :translations, Translations
  end
end
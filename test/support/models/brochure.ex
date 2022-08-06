defmodule Cldr.Trans.Brochure do
  use Ecto.Schema
  use MyApp.Cldr.Trans, translates: [:title, :body]

  schema "articles" do
    field :title, :string
    field :body, :string
    translations :translations
  end
end

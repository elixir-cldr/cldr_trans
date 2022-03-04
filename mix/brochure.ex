defmodule Cldr.Trans.Brochure do
  use Ecto.Schema
  use MyApp.Cldr.Trans, translates: [:title, :body]

  schema "magazine" do
    field :title, :string
    field :body, :string
    translations :translations
  end
end

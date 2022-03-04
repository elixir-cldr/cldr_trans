defmodule Cldr.TransTest do
  use Cldr.Trans.TestCase

  alias Cldr.Trans
  alias Cldr.Trans.{Article, Comment, Book}

  doctest Trans

  test "checks whether a field is translatable or not given a module" do
    assert Trans.translatable?(Article, :title) == true
    assert Trans.translatable?(Article, "title") == true
    assert Trans.translatable?(Article, :fake_field) == false
  end

  test "checks whether a field is translatable or not given a struct" do
    with article <- build(:article) do
      assert Trans.translatable?(article, :title) == true
      assert Trans.translatable?(article, "title") == true
      assert Trans.translatable?(article, :fake_field) == false
    end
  end

  test "returns the default translation container when unspecified" do
    assert Article.__trans__(:container) == :translations
  end

  test "the default locale" do
    defmodule Book do
      use Trans, translates: [:title, :body], default_locale: :en
      defstruct title: "", body: "", translations: %{}
    end

    assert Book.__trans__(:default_locale) == :en
    assert Article.__trans__(:default_locale) == nil
  end

  test "returns the custom translation container name if specified" do
    assert Comment.__trans__(:container) == :transcriptions
  end

  test "compilation fails when translation container is not a valid field" do
    invalid_module =
      quote do
        defmodule TestArticle do
          use Trans, translates: [:title, :body], container: :invalid_container
          defstruct title: "", body: "", translations: %{}
        end
      end

    assert_raise ArgumentError,
                 "The field invalid_container used as the translation container is not defined in TestArticle struct",
                 fn -> Code.eval_quoted(invalid_module) end
  end

  test "translations/3 macro" do
    assert :translations in Trans.Magazine.__schema__(:fields)

    assert {
      :parameterized, Ecto.Embedded,
      %Ecto.Embedded{
        cardinality: :one,
        field: :translations,
        on_cast: nil,
        on_replace: :update,
        ordered: true,
        owner: Trans.Magazine,
        related: Trans.Magazine.Translations,
        unique: true}} =
      Trans.Magazine.__schema__(:type, :translations)

     assert [:es, :it, :de] = Trans.Magazine.Translations.__schema__(:fields)
     assert [:title, :body] = Trans.Magazine.Translations.Fields.__schema__(:fields)
  end

  test "MyApp.Cldr.Trans.translations/3 macro" do
    assert :translations in Cldr.Trans.Brochure.__schema__(:fields)

    assert {
      :parameterized, Ecto.Embedded,
      %Ecto.Embedded{
        cardinality: :one,
        field: :translations,
        on_cast: nil,
        on_replace: :update,
        ordered: true,
        owner: Cldr.Trans.Brochure,
        related: Cldr.Trans.Brochure.Translations,
        unique: true}} =
      Cldr.Trans.Brochure.__schema__(:type, :translations)

     assert [:ar, :de, :doi, :en, :"en-001", :"en-AU", :fr, :"fr-CA", :ja, :nb, :no, :pl, :th] =
       Cldr.Trans.Brochure.Translations.__schema__(:fields)
     assert [:title, :body] = Cldr.Trans.Brochure.Translations.Fields.__schema__(:fields)
  end
end

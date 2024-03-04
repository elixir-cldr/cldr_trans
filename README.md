# Cldr Trans
![Build status](https://github.com/elixir-cldr/cldr_trans/actions/workflows/ci.yml/badge.svg)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_trans.svg)](https://hex.pm/packages/ex_cldr_trans)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_trans.svg?)](https://hex.pm/packages/ex_cldr_trans)
[![Hex.pm](https://img.shields.io/hexpm/dt/ex_cldr_trans.svg?)](https://hex.pm/packages/ex_cldr_trans)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_trans.svg)](https://hex.pm/packages/ex_cldr_trans)

## Installation

The package can be installed by adding `ex_cldr_trans` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cldr_trans, "~> 1.0"}
  ]
end
```
Documentation can be found at [https://hexdocs.pm/ex_cldr_trans](https://hexdocs.pm/ex_cldr_trans).

## Attribution

`ex_cldr_trans` is an `ex_cldr`-integrated fork of the excellent [trans](https://github.com/crbelaus/trans) by [@crbelaus](https://github.com/crbelaus). The enhancements in this library have been been submitted as a [PR](https://github.com/crbelaus/trans/pull/74) to `trans`. If the PR is accepted in the future then this library will revert to depending on it rather than maintaining a fork.  Such a change will not affect the functionality or API in this library.

The documentation in `cldr_trans` is edited from the original `trans` documentation.

### Introduction

`ex_cldr_trans` provides a way to manage and query translations embedded into schemas
and removes the necessity of maintaining extra tables only for translation storage. It is an addon library to [ex_cldr](https://hex.pm/packages/ex_cldr).

`ex_cldr_trans` is published on [hex.pm](https://hex.pm/packages/ex_cldr_trans) and the documentation
is also [available online](https://hexdocs.pm/ex_cldr_trans/).

## Optional Requirements

Having Ecto SQL and Postgrex in your application will allow you to use the `Cldr.Trans.QueryBuilder`
component to generate database queries based on translated data.  You can still
use the `Cldr.Trans.Translator` component without those dependencies though.

- [Ecto SQL](https://hex.pm/packages/ecto_sql) 3.0 or higher
- [PostgreSQL](https://hex.pm/packages/postgrex) 9.4 or higher (since `Cldr.Trans` leverages the JSONB datatype)


## Why CLDR Trans?

The traditional approach to content internationalization consists on using an
additional table for each translatable schema. This table works only as a storage
for the original schema translations. For example, we may have a `posts` and
a `posts_translations` tables.

This approach has a few disadvantages:

- It complicates the database schema because it creates extra tables that are
  coupled to the "main" ones.
- It makes migrations and schemas more complicated, since we always have to keep
  the two tables in sync.
- It requires constant JOINs in order to filter or fetch records along with their
  translations.

The approach used by `Cldr.Trans` is based on modern RDBMSs support for unstructured
datatypes.  Instead of storing the translations in a different table, each
translatable schema has an extra column that contains all of its translations.
This approach drastically reduces the number of required JOINs when filtering or
fetching records.

`Cldr.Trans` is lightweight and modularized. The `Cldr.Trans` module provides metadata
that is used by the `Cldr.Trans.Translator` and `Cldr.Trans.QueryBuilder` modules, which
implement the main functionality of this library.

## Quickstart

Imagine that we have an `Article` schema that we want to translate:

```elixir
defmodule MyApp.Article do
  use Ecto.Schema

  schema "articles" do
    field :title, :string
    field :body, :string
  end
end
```

### Add a JSON column

The first step would be to add a new JSON column to the table so we can store the translations in it.

```elixir
defmodule MyApp.Repo.Migrations.AddTranslationsToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :translations, :map
    end
  end
end
```

### Generate database function migration

`ex_cldr_trans` defines a Postgres database function to support in-db field translation. A migration task is provided to generate the migration required to define this function.

```elixir
% MIX_ENV=test mix cldr.trans.gen.translate_function
* creating priv/repo/migrations
* creating priv/repo/migrations/20220307212312_trans_gen_translate_function.exs
```

### Run migrations

Migrate the database to add the translations column and define the database function.
```elixir
% mix ecto.migrate
```

### Define a backend module

The next step is to define an [ex_cldr](https://hex.pm/packages/ex_cldr) [backend module](https://hexdocs.pm/ex_cldr/readme.html#backend-module-configuration) that defines the configured locales and other information for supporting localised applications.  For example:

```elixir
defmodule MyApp.Cldr do
  use Cldr,
    locales: ["en", "de", "ja", "en-AU", "th", "ar", "pl", "doi", "fr-CA", "nb", "no"],
    providers: [Cldr.Trans]

end
```

Note that for existing backend modules the only required step is to add `Cldr.Trans` to the list of `:providers`.

### Add translations to schema

Once we have the new database column and the backend module, we can update the Article schema to include the translations:

```elixir
defmodule MyApp.Article do
  use Ecto.Schema
  use MyApp.Cldr.Trans, translates: [:title, :body]

  schema "articles" do
    field :title, :string
    field :body, :string
    # use the 'translations' macro to set up a map-field with a set of nested
    # structs to handle translation values for each configured locale and each
    # translatable field
    translations :translations
  end
```

### Casting translations

`ex_cldr_trans` will generate a simple default changeset for the translations
field. It looks like this:

```elixir
def changeset(fields, params) do
  fields
  |> cast(params, list_of_translatable_fields)
  |> validate_required(list_of_translatable_fields)
end
```

Which means that it is only checking that translations are non-empty for each translatable
field in each locale configured in `MyApp.Cldr`.  That may not be flexible enough for all
requirements. Therefore a custom changeset may need to be defined for the translations field.
Here's one example:

```elixir
  def changeset(article, params \\ %{}) do
    article
    |> cast(params, [:title, :body])
    # use 'cast_embed' to cast values for the 'translations' field.
    |> cast_embed(:translations, with: &translations_changeset/2)
    |> validate_required([:title, :body])
  end

  # This is the changeset that will be invoked by the
  # cast_embed/3 call above.
  defp translations_changeset(translations, params) do
    translations
    |> cast(params, [])
    # use 'cast_embed' to handle values for translated fields for each of the
    # configured languages with a changeset defined by the 'translations' macro
    # above. Assumes that `:en` (the default), `:es` and `:fr` are configured in
    # `MyApp.Cldr`.
    |> cast_embed(:es)
    |> cast_embed(:fr)
  end
end
```

### Query Building and Forms

After doing this we can leverage the [Cldr.Trans.Translator](https://hexdocs.pm/ex_cldr_trans/Cldr.Trans.Translator.html) and [Cldr.Trans.QueryBuilder](https://hexdocs.pm/ex_cldr_trans/Cldr.Trans.QueryBuilder.html) modules to fetch and query translations from the database.

The translation storage can be managed using normal `Ecto.Changeset` functions just like any other field. Leveraging changesets and the [Phoenix.HTML.Form.inputs_for/2](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#module-nested-inputs) helper, your HTML form for `Article` might look like:

```
<.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
  <%= label f, :title %>
  <%= text_input f, :title %>
  <%= error_tag f, :title %>

  <!-- translations for 'title' field -->
  <%= inputs_for f, :translations, fn form_translations -> %>
  <%= for locale <- [:es, :fr] do %>
    <%= inputs_for form_translations, locale, fn form_locale -> %>
    <div>
      <span><%= "#{locale}" %></span>
      <%= text_input form_locale, :title, placeholder: Map.get(@changeset.data, :title) %>
    </div>
    <%= error_tag form_locale, :title %>
  <% end %>

  <%= label f, :body %>
  <%= text_input f, :body %>
  <%= error_tag f, :body %>

  <!-- translations for 'body' field -->
  <%= inputs_for f, :translations, fn form_translations -> %>
  <%= for locale <- [:es, :fr] do %>
    <%= inputs_for form_translations, locale, fn form_locale -> %>
    <div>
      <span><%= "#{locale}" %></span>
      <%= text_input form_locale, :body, placeholder: Map.get(@changeset.data, :body) %>
    </div>
    <%= error_tag form_locale, :body %>
  <% end %>

  <%= submit "Save" %>
</.form>
```


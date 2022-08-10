defmodule MyApp.Cldr do
  use Cldr,
    gettext: MyApp.Gettext,
    locales: ["en", "de", "ja", "en-AU", "th", "ar", "pl", "doi", "fr-CA", "nb", "no"],
    default_locale: "en-001",
    generate_docs: true,
    providers: [Cldr.Trans]
end

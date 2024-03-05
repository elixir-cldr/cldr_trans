# Changelog

## Cldr Trans v1.1.2

This is the changelog for Cldr Trans version 1.1.2 released on March 6th, 2024.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_trans/tags)

### Bug Fixes

* Mnaully generates the translations embedded_scheam and adds `@moduledoc false` to it to reduce noise. This concludes the work to ensure generated modules don't have docs in them (since they are empty and have no developer value).

## Cldr Trans v1.1.1

This is the changelog for Cldr Trans version 1.1.1 released on March 5th, 2024.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_trans/tags)

### Bug Fixes

* Adds `@moduledoc false` to the translations field generated modules to reduce noise. Thanks to @ArthurClemens for the issue. Closes #9.

### Enhancements

* Improve the clarity of the documentation in the README and the `Cldr.Trans` modules.

## Cldr Trans v1.1.0

This is the changelog for Cldr Trans version 1.1.0 released on August 10th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_trans/tags)

### Enhancements

* By default uses the default locale on the Cldr backend as the assumed locale of the non-translated field. Don't generate translations struct for the default locale either. This enhancement kindly contributed by @petrus-jvrensburg,

## Cldr Trans v1.0.0

This is the changelog for Cldr Trans version 1.0.0 released on March 27th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_trans/tags)

### Enhancements

* Publish official 1.0 release

## Cldr Trans v1.0.0-rc.0

This is the changelog for Cldr Trans version 1.0.0-rc.0 released on March 8th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_trans/tags)

### Enhancements

Initial release forked from [trans](https://github.com/crbelaus/trans) with enhancements to integrate with [ex_cldr](https://hex.pm/packages/ex_cldr).

The primary differences from `trans` are:
* Infers configured locales from the CLDR backend module
* Uses the locale fallback chain to find a translation
* Executes in-database translations via a database function
* Returns NULL (not JSON 'Null') for all cases


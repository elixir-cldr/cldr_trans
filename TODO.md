# TODO

Known defects and parked work in `ex_cldr_trans`. The library is in maintenance mode (see `STATUS.md`): defects users report are fixed and released, while defects found in review are recorded here and deferred, because development time goes to Localize. An item is revived when someone reports it.

## Deferred

* [ ] **Custom per-locale `Fields` module** — let `translations/3` take the module used for each locale's embed, so it can carry extra fields such as an update timestamp or a machine-translated flag (issue #5). Functional work, parked by maintenance mode; writing the `embeds_one :translations … do … end` block by hand, as the `Cldr.Trans.Book` test model does, gives the same today.

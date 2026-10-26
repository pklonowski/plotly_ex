# Schema provenance

`plotly_schema.json` is the unmodified `plotly/validators/_validators.json`
from the official **plotly.py 7.1.0** wheel, retrieved on 2026-10-24.

- Wheel: [plotly-7.1.0-py3-none-any.whl](https://files.pythonhosted.org/packages/e5/7d/905a3a3d51087515719058c94cfbda2ff0fc14417c20d557ae3e82d8b250/plotly-7.1.0-py3-none-any.whl)
- Wheel SHA-256: `dbb7fa18afce40d0a8e80d1bf162eceb3faa0ce5a77fe741ad09a74cf78f53f3`
- Extracted schema SHA-256: `38f0866fdc77fd4cc202465ddcc30d45c8395d42839a6283bbf500e8e8554db5`
- Bundled plotly.js version in that wheel: **4.1.1**.
- Target plotly.js version for plotly_ex: **4.1.2**.

The official [4.1.1 schema](https://raw.githubusercontent.com/plotly/plotly.js/v4.1.1/dist/plot-schema.json)
and [4.1.2 schema](https://raw.githubusercontent.com/plotly/plotly.js/v4.1.2/dist/plot-schema.json)
have identical `traces` and `layout` structure after recursively excluding
`description` keys. The colorbar `dtick` descriptions differ, as do config
`toImageButtonOptions` descriptions. These differences do not affect generated
fields or validation metadata. The Elixir generator consumes the flattened
Python validator format, not the JavaScript schema format.

## Refresh

Download the official wheel into a scratch directory, verify its checksum
against [PyPI metadata](https://pypi.org/pypi/plotly/7.1.0/json), then extract:

```sh
unzip -p /tmp/plotly-7.1.0-py3-none-any.whl plotly/validators/_validators.json > priv/schema/plotly_schema.json
sha256sum priv/schema/plotly_schema.json
mix plotly.gen
mix format
mix test test/plotly/codegen_test.exs test/plotly/schema_v4_test.exs test/plotly/traces test/plotly/layout_test.exs
```

For a later release, first compare the target JavaScript trace/layout schema
with the version bundled by the wheel. Update this provenance record and the
schema checksum test together. Never patch validator fields by hand.

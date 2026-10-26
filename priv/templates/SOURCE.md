# Named template provenance

These ten JSON files are unmodified from `plotly/package_data/templates/` in
the official Plotly.py **7.1.0** wheel, which bundles Plotly.js 4.1.1 and uses
the same trace/layout schema as our vendored 4.1.2 bundle. The comparison is
recorded in the repository's `priv/schema/SOURCE.md`.

Source: [official wheel](https://files.pythonhosted.org/packages/e5/7d/905a3a3d51087515719058c94cfbda2ff0fc14417c20d557ae3e82d8b250/plotly-7.1.0-py3-none-any.whl).

Wheel SHA-256: `dbb7fa18afce40d0a8e80d1bf162eceb3faa0ce5a77fe741ad09a74cf78f53f3`.
The upstream MIT license is included as `LICENSE.txt`.

`Plotly.Templates` embeds these definitions at compile time. The extra `none`
name resolves to an empty object. No Python runtime or template CDN is needed.
To refresh, verify the wheel checksum, extract its template JSON files unchanged,
update these checksums, and run `mix test test/plotly/named_templates_test.exs`.

| File | SHA-256 |
|---|---|
| `ggplot2.json` | `1f54a47384660e6326d011720ce0f1cd92c2b8b7f10ca36be50619d9ab64e25c` |
| `gridon.json` | `fec765e07b924710fb4ca037c8e38a83b4d6eb9b3fd72bb9bf1f3cb3037fb001` |
| `plotly.json` | `d79218b426c2e149df4c0fed3e9cba8b3d498e5e6dc768186889003641c3107e` |
| `plotly_dark.json` | `23a53f00102a4d402b6f0b72b4cd3c61b00ccde8d9e540d2c457e6632db676d2` |
| `plotly_white.json` | `337175af8c090c8c5218b22b513a3009a2422783e4fc37ae262f7fad018c5a18` |
| `presentation.json` | `2fe19142c2c06732b5df2c83896535954206c508339da7dcd6191b6df5ac9475` |
| `seaborn.json` | `b6672f3048399e4bf9bea12d4ccf760f4e652bb6cac380c9fe7bbdf11bf3d0b0` |
| `simple_white.json` | `954d9daaa522251675fa2f8727441a811895e8a5f1cdeb3c1fd083f6c7235894` |
| `xgridoff.json` | `a4a8b8eb5b12358c42f6e11f4dcc376e752e0ed13b827c17fb81b47cc26bd544` |
| `ygridoff.json` | `1440f2bb067b90406c4dadc008f208e7471694752e0aaa4a042d3cc40f8a3fe3` |

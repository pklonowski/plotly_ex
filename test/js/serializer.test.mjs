import test from "node:test";
import assert from "node:assert/strict";
import * as hook from "../../priv/static/plotly_hook.js";
import * as kino from "../../priv/plotly_js/plotly_live.js";
import { fixtures } from "./event_fixtures.mjs";

for (const [name, adapter] of [["LiveView", hook], ["Kino", kino]]) {
  for (const fixture of fixtures) {
    test(`${name}: ${fixture.name}`, () => {
      assert.equal(typeof adapter.serializePlotlyEvent, "function");
      const result = adapter.serializePlotlyEvent(fixture.input, fixture.type);
      assert.deepEqual(JSON.parse(JSON.stringify(result)), fixture.expected);
    });
  }
}

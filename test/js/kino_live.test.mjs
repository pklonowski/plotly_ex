import test from "node:test";
import assert from "node:assert/strict";
import { init } from "../../priv/plotly_js/plotly_live.js";
import { browser, nextTurn } from "./browser_helpers.mjs";
import { fixtures } from "./event_fixtures.mjs";

test("Kino init registers all events and forwards the shared contract as JSON", async t => {
  const env = browser(t);
  const pushed = [];
  const updates = new Map();
  const ctx = {
    root: env.el,
    pushEvent: (...args) => pushed.push(args),
    handleEvent: (name, handler) => updates.set(name, handler)
  };
  init(ctx, JSON.stringify({ figureJson: env.el.dataset.figure, plotlyUrls: [], version: "4.1.2" }));
  await nextTurn();
  assert.deepEqual([...env.handlers.keys()].sort(),
    ["plotly_click", "plotly_hover", "plotly_unhover", "plotly_relayout", "plotly_selected"].sort());
  for (const fixture of fixtures) {
    env.handlers.get(fixture.type)[0](fixture.input);
    const [event, payload] = pushed.at(-1);
    assert.equal(event, "plotly_event");
    assert.deepEqual(JSON.parse(payload), { type: fixture.type, data: fixture.expected });
  }
  await updates.get("update")('{"data":[{"type":"quiver","x":[0],"y":[0],"u":[1],"v":[1]}]}');
  assert.equal(env.calls.filter(([name]) => name === "react").length, 1);
});

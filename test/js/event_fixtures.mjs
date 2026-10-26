const emptyPoint = {
  x: null, y: null, z: null, curveNumber: null, pointNumber: null,
  pointIndex: null, text: null, customdata: null, name: null, bbox: null,
  xPixel: null, yPixel: null
};
const emptyData = { points: [], xvals: null, yvals: null, xPixel: null, yPixel: null };
const event = {};
event.target = event; // DOM events can contain cycles; never serialize them.
export const fixtures = [
  {
    name: "hover distinguishes cursor pixels from point pixels and keeps date values",
    type: "plotly_hover",
    input: { points: [{ x: "2026-01-01", y: 0, curveNumber: 0, pointNumber: 0,
      text: "", customdata: false, data: { name: "Field" }, bbox: { x0: 10, x1: 20 },
      xPixel: 15, yPixel: 25 }], xvals: ["2026-01-01"], yvals: [0], xPixel: 18, yPixel: 28,
      xaxes: [event], event },
    expected: { points: [{ ...emptyPoint, x: "2026-01-01", y: 0, curveNumber: 0,
      pointNumber: 0, text: "", customdata: false, name: "Field", bbox: { x0: 10, x1: 20 },
      xPixel: 15, yPixel: 25 }], xvals: ["2026-01-01"], yvals: [0], xPixel: 18, yPixel: 28 }
  },
  { name: "anywhere events retain coordinates without points", type: "plotly_hover",
    input: { points: [], xvals: ["category"], yvals: [2], xPixel: 0, yPixel: 3, event },
    expected: { points: [], xvals: ["category"], yvals: [2], xPixel: 0, yPixel: 3 } },
  { name: "click missing fields become explicit nulls", type: "plotly_click",
    input: { points: [{ x: 1 }], event }, expected: { ...emptyData, points: [{ ...emptyPoint, x: 1 }] } },
  { name: "unhover carries old point pixels without cursor coordinates", type: "plotly_unhover",
    input: { points: [{ xPixel: 20, yPixel: 30 }], event },
    expected: { ...emptyData, points: [{ ...emptyPoint, xPixel: 20, yPixel: 30 }] } },
  { name: "selection with missing points normalizes to an empty point event", type: "plotly_selected",
    input: undefined, expected: emptyData },
  { name: "relayout retains its original JSON shape", type: "plotly_relayout",
    input: { "xaxis.range[0]": 1, "xaxis.range[1]": 3 },
    expected: { "xaxis.range[0]": 1, "xaxis.range[1]": 3 } }
];

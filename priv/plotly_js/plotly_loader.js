// priv/plotly_js/plotly_loader.js
// Shared by the Kino static + live entrypoints.

export function loadPlotly(urls) {
  if (window.Plotly) return Promise.resolve();
  return new Promise((resolve, reject) => {
    const tryLoad = (i) => {
      if (window.Plotly) return resolve();
      if (i >= urls.length) return reject(new Error("plotly_ex: all plotly.js sources failed"));
      const s = document.createElement("script");
      s.src = urls[i];
      s.onload = () => {
        if (i > 0) {
          console.warn(
            "plotly_ex: primary plotly.js source was unreachable; fell back to " +
              urls[i] + ". The bundled copy is an offline fallback vendored with plotly_ex."
          );
        }
        resolve();
      };
      s.onerror = () => tryLoad(i + 1);
      document.head.appendChild(s);
    };
    tryLoad(0);
  });
}

export function loadLocale(version, locale) {
  if (!locale || !version) return Promise.resolve();
  return loadScript(
    `https://cdn.jsdelivr.net/npm/plotly.js@${version}/dist/plotly-locale-${locale}.min.js`
  );
}

export function loadScript(src) {
  return new Promise((resolve) => {
    if (document.querySelector(`script[src="${src}"]`)) return resolve();
    const s = document.createElement("script");
    s.src = src;
    s.onload = resolve;
    s.onerror = resolve;
    document.head.appendChild(s);
  });
}

let mathJaxPromise = null;

// Each chart awaits the same script load AND startup, including concurrent callers.
export async function loadMathJax() {
  if (mathJaxPromise) return mathJaxPromise;
  mathJaxPromise = (async () => {
    if (window.MathJax?.typesetPromise) {
      await window.MathJax.startup?.promise;
      return;
    }
    window.MathJax = {
      tex: { inlineMath: [["$", "$"]] },
      svg: { fontCache: "local" },
      startup: { typeset: false }
    };
    await new Promise((resolve, reject) => {
      const script = document.createElement("script");
      script.src = "https://cdn.jsdelivr.net/npm/mathjax@4/tex-svg.js";
      script.onload = resolve;
      script.onerror = () => {
        script.remove?.();
        reject(new Error("plotly_ex: MathJax could not be loaded"));
      };
      document.head.appendChild(script);
    });
    await window.MathJax.startup?.promise;
  })().catch((error) => {
    // MathJax is optional: every waiting chart can still render plain text.
    console.warn(error.message);
  }).finally(() => {
    mathJaxPromise = null;
  });
  return mathJaxPromise;
}

export function resolveRawJS(value) {
  if (value === null || value === undefined) return value;
  if (Array.isArray(value)) return value.map(resolveRawJS);
  if (typeof value === "object") {
    if ("__rawjs__" in value) {
      try {
        return new Function("return (" + value["__rawjs__"] + ")")();
      } catch (e) {
        return undefined;
      }
    }
    const out = {};
    for (const [k, v] of Object.entries(value)) out[k] = resolveRawJS(v);
    return out;
  }
  return value;
}

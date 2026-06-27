# AGENTS.md — dropecho.easings

Single source of truth for all AI agents working on this project.

## Agent Instructions

- **Always use the `haxe` skill** when reading or writing any `.hx` or `.hxml` file.
- **Always use the Haxe LSP** (`LSP` tool) for navigating code — go-to-definition, find references, hover types — before grepping or reading files manually.
- **Never co-author or co-sign commits.** Do not add `Co-Authored-By` trailers, `Signed-off-by` lines, or any other attribution/sign-off trailers to commit messages.
- **Never add section/region divider comments** (e.g. `// ── Foo ──`, `// --- Foo ---`, `#region`). Organize code with ordering and doc comments instead.

---

## Project Overview

**dropecho.easings** (`haxelib: dropecho.easings`, npm: `@dropecho/easings`) is a small
library of easing functions (linear transformations) and math helpers for games and
animation. It compiles to JS (CommonJS + ES module) and C#.

- **Version:** 0.1.0
- **License:** MIT
- **Targets:** JS (CommonJS), JS (ES module + `.d.ts` via genes), C# (DLL)
- **Test runner:** `dropecho.testing` (auto-discovery) over `utest`; `instrument` for coverage
- **Source root:** `src/`  · **Tests root:** `test/`
- **Releases:** automated via `semantic-release` (+ `semantic-release-haxelib`)
- **Dependency:** `dropecho.macros` (provides the compile-time `MathMacros.pow` macro)

---

## Source Modules

| Module | Path | Description |
|---|---|---|
| `Easings` | `src/dropecho/Easings.hx` | Static easing/interpolation functions: `clamp`, `rangeMap`, `rangeMapClamped`, `mix`/`lerp`, `easeIn{Quad,Cubic,Quart,Quint}`, `easeOut{Quad,Cubic,Quart,Quint}`, `easeInSine`, `smoothStep`, `scale`. Exposed to JS via `@:expose("easings")` |

The `pow` macro that the polynomial eases build on now lives in **`dropecho.macros`**
(`dropecho.macros.MathMacros.pow`); it is pulled in as a dependency.

All public functions in `Easings` are `static inline`, so calls are inlined at the call
site. `easeInSine` is the only one with non-trivial cost (it calls `Math.cos`); every
other ease compiles to a few inlined arithmetic ops (see **Benchmarks**).

---

## Directory Layout

```
src/dropecho/            # library source
  Easings.hx             # easing + interpolation functions
test/                    # utest cases, auto-discovered by filename (*Tests.hx)
  EasingsTests.hx
  EasingsBenchTests.hx   # benchmarks, gated behind -D RUN_BENCHMARKS
  easings/               # per-function test classes
    MixTests.hx
    RangeMapTests.hx
    RangeMapClampedTests.hx
build.hxml               # multi-target build (shared opts + --each/--next)
targets/                 # one hxml per target (js, js-esm, cs)
.dropecho.testing.json   # test-runner config (coverage, root_package, hxml)
dist/                    # compiled output (js/cjs/index.cjs, js/esm/index.js, cs/dropecho.easings)
artifacts/               # compiled test output + coverage reports
```

There is no hand-written test main/suite: `dropecho.testing` generates the entry point
and registers every `*Tests.hx` class on the classpath (note the plural — `Test.hx`
files are **not** discovered).

---

## Build & Test

Prefer `npm` scripts over invoking Haxe tools directly.

```bash
# Install/resolve Haxe deps (lix, scoped to haxe_libraries/)
npm install          # → lix download

# Build (JS CommonJS + JS ES module + C# DLL)
npm run build        # → npm run clean && haxe build.hxml

# Run tests
npm test             # → lix run dropecho.testing

# Run benchmarks (builds with -D RUN_BENCHMARKS, then runs on Node)
npm run bench
```

Dependencies are managed with **lix** (`resolveLibs: scoped` in `.haxerc`); each lib is
pinned by a lock file in `haxe_libraries/`. `npm install` runs `lix download` to fetch
them into the lix cache.

- `build.hxml` puts shared options (class path, `--macro include`, `-lib dropecho.macros`,
  `-D analyzer-optimize`) before `--each`, then builds each `targets/*.hxml` separated by
  `--next`: JS CommonJS to `dist/js/cjs/index.cjs` (`-D js-es=6`, source maps); JS ES module
  to `dist/js/esm/index.js` (+ `.d.ts` typings via genes); and C# to `dist/cs/dropecho.easings`
  (`-D dll`).
- `test.hxml` lists libs/targets only — **no `-main`**. The `dropecho.testing` runner
  injects `--main dropecho.testing.AutoTest` (and instrument/coverage from
  `.dropecho.testing.json`), then runs each target it finds in the hxml (`-js
  artifacts/js_test.cjs` on Node).
- `npm run bench` bypasses the runner and calls `haxe` directly with `-D RUN_BENCHMARKS`
  so benchmarks build **uninstrumented** for accurate timings.

---

## Key Conventions

- `@:expose("easings")` on the public `Easings` class for the JS bundle
- Prefer `static inline public` functions for the math/easing helpers
- Use the `dropecho.macros.MathMacros.pow` macro instead of `Math.pow` for integer
  exponents (it unrolls to multiplications and is the basis for the `easeIn*`/`easeOut*`
  polynomial families)
- Tests are `utest` cases: each class is named `*Tests.hx`, `extends utest.Test`, with
  `test_`-prefixed methods and `utest.Assert` (use `Assert.floatEquals` for floats)
- Benchmarks live in `EasingsBenchTests.hx` behind `#if (RUN_BENCHMARKS && (sys ||
  nodejs))`, timed with `Sys.cpuTime()` over tight inlined loops vs. a baseline

---

## Benchmarks

`npm run bench` reports per-call cost for each function (50M iterations, Node). The arithmetic
eases are all at the inlining floor (~0.5–1 ns/call, i.e. effectively free). The lone hot
path is **`easeInSine`** at ~5 ns/call (~6–10× the others) because of `Math.cos` — that cost
is intrinsic to the trig call, not the surrounding code. If a project needs it faster and can
tolerate approximation error, swap in a polynomial cosine approximation; otherwise leave it,
as `Math.cos` is the accurate choice and 5 ns is still ~200M calls/sec.

**`MathMacros.pow` vs `Math.pow`** (same exponent, identical results): the macro unrolls to
repeated multiplication at compile time, so its cost is flat and near the inlining floor
(~0.5 ns at `^2`, ~0.75 ns at `^5`). `Math.pow` is a runtime call — V8 special-cases `^2`
(~0.64 ns) but takes the generic `exp(y·log(x))` path for higher integer exponents (~12 ns at
`^5`). So the macro is ~1.2× faster at `^2` and **~16× faster at `^5`**; the payoff scales with
the exponent, which is exactly why the `easeIn*`/`easeOut*` polynomial families use it.

# dropecho.easings

A small Haxe library of easing functions (linear transformations) and interpolation
helpers for games and animation. Compiles to JavaScript and C#.

## Install

```bash
haxelib install dropecho.easings   # Haxe
npm install @dropecho/easings      # JavaScript
```

## Usage

Easing functions take a normalized time `t` in `[0, 1]` and return the eased value,
also in `[0, 1]`.

### Haxe

```haxe
import dropecho.Easings;

Easings.easeInQuad(0.25);                  // 0.0625
Easings.easeOutCubic(0.25);                // 0.578125
Easings.smoothStep(0.5);                   // 0.5
Easings.mix(0, 100, 0.25);                 // 25   (lerp is an alias)
Easings.rangeMap(0.25, 0, 1, 0, 255);      // 63.75
Easings.rangeMapClamped(5, 0, 1, 0, 255);  // 255  (input clamped to the in-range)
Easings.clamp(value, 0, 1);
```

### JavaScript

The library is exposed as the `easings` object (CommonJS export, or a global in the browser).

```js
const { easings } = require("@dropecho/easings");

easings.easeInQuad(0.25); // 0.0625
easings.smoothStep(0.5);  // 0.5
```

## API

| Group | Functions |
|---|---|
| Range / interpolation | `clamp`, `rangeMap`, `rangeMapClamped`, `mix`, `lerp` |
| Ease in (accelerate from 0) | `easeInQuad`, `easeInCubic`, `easeInQuart`, `easeInQuint`, `easeInSine` |
| Ease out (decelerate to 1) | `easeOutQuad`, `easeOutCubic`, `easeOutQuart`, `easeOutQuint` |
| Composite / misc | `smoothStep`, `scale` |

- **`rangeMap`** extrapolates outside the in-range; **`rangeMapClamped`** pins the result to
  the out-range and handles inverted in-ranges (`inMin > inMax`).
- **`scale(t, easing)`** returns `t · easing(t)`, a cheap way to sharpen an ease.

## Development

```bash
npm run build   # build JS + C#
npm test        # run the utest suite (via dropecho.testing)
npm run bench   # run the benchmarks
```

## License

MIT

package dropecho;

/**
 * A small collection of easing and interpolation helpers.
 *
 * The easing functions (`easeIn*`, `easeOut*`, `easeInSine`, `smoothStep`) take a
 * normalized time `t` in `[0, 1]` and return the eased value, also in `[0, 1]`.
 * The range and interpolation helpers (`clamp`, `rangeMap`, `mix`/`lerp`) are
 * general-purpose and accept any range.
 *
 * Exposed to JavaScript as the `easings` object via `@:expose`.
 */
@:expose("easings")
class Easings {
	/** Constrain `value` to the inclusive range `[min, max]`. */
	static inline public function clamp(value:Float, min:Float, max:Float):Float {
		return Math.min(Math.max(value, min), max);
	}

	/**
	 * Linearly remap `value` from `[inMin, inMax]` onto `[outMin, outMax]`.
	 *
	 * The input is not clamped, so values outside the in-range extrapolate beyond
	 * the out-range. Use `rangeMapClamped` to pin the result to the out-range.
	 */
	static inline public function rangeMap(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
	}

	/**
	 * Like `rangeMap`, but `value` is first clamped to the in-range so the result
	 * always stays within `[outMin, outMax]`. Inverted in-ranges (`inMin > inMax`)
	 * are handled.
	 */
	static inline public function rangeMapClamped(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		value = inMin > inMax ? clamp(value, inMax, inMin) : clamp(value, inMin, inMax);
		return rangeMap(value, inMin, inMax, outMin, outMax);
	}

	/** Linearly interpolate from `a` to `b` by `amount` (`0` → `a`, `1` → `b`). */
	static inline public function mix(a:Float, b:Float, amount:Float):Float {
		return ((1 - amount) * a) + (amount * b);
	}

	/** Alias of `mix`. */
	static inline public function lerp(a:Float, b:Float, amount:Float):Float {
		return mix(a, b, amount);
	}

	/** Quadratic ease-in: `t²`. */
	static inline public function easeInQuad(t:Float):Float {
		return MathMacros.pow(t, 2);
	}

	/** Cubic ease-in: `t³`. */
	static inline public function easeInCubic(t:Float):Float {
		return MathMacros.pow(t, 3);
	}

	/** Quartic ease-in: `t⁴`. */
	static inline public function easeInQuart(t:Float):Float {
		return MathMacros.pow(t, 4);
	}

	/** Quintic ease-in: `t⁵`. */
	static inline public function easeInQuint(t:Float):Float {
		return MathMacros.pow(t, 5);
	}

	/** Sine ease-in: `1 - cos(t·π/2)`. */
	static inline public function easeInSine(t:Float):Float {
		return 1 - Math.cos((t * Math.PI) / 2);
	}

	/** Quadratic ease-out: `1 - (1 - t)²`. */
	static inline public function easeOutQuad(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 2);
	}

	/** Cubic ease-out: `1 - (1 - t)³`. */
	static inline public function easeOutCubic(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 3);
	}

	/** Quartic ease-out: `1 - (1 - t)⁴`. */
	static inline public function easeOutQuart(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 4);
	}

	/** Quintic ease-out: `1 - (1 - t)⁵`. */
	static inline public function easeOutQuint(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 5);
	}

	/** Smooth start-and-stop S-curve, blending quadratic ease-in and ease-out. */
	static inline public function smoothStep(t:Float):Float {
		return mix(easeInQuad(t), easeOutQuad(t), t);
	}

	/**
	 * Scale `easing(t)` by the raw time `t`, i.e. `t · easing(t)`.
	 *
	 * Multiplying by `t` biases the curve toward 0, a cheap way to sharpen an
	 * ease-in (e.g. `scale(t, easeInQuad)` behaves like `easeInCubic`).
	 */
	static inline public function scale(t:Float, easing:Float->Float):Float {
		return t * easing(t);
	}
}

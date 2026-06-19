package dropecho;

import dropecho.macros.MathMacros;

/**
A small collection of easing and interpolation helpers.

The easing functions (`easeIn*`, `easeOut*`, `easeInSine`, `smoothStep`) take a
normalized time `t` in `[0, 1]` and return the eased value, also in `[0, 1]`.
The range and interpolation helpers (`clamp`, `rangeMap`, `mix`/`lerp`) are
general-purpose and accept any range.

Exposed to JavaScript as the `easings` object via `@:expose`.
**/
@:expose("easings")
class Easings {
	/**
	Constrain `value` to the inclusive range `[min, max]`.

	@param value The value to clamp.
	@param min The lower bound.
	@param max The upper bound.
	@return `value` limited to `[min, max]`.
	**/
	public static inline function clamp(value:Float, min:Float, max:Float):Float {
		return Math.min(Math.max(value, min), max);
	}

	/**
	Linearly remap `value` from `[inMin, inMax]` onto `[outMin, outMax]`.

	The input is not clamped, so values outside the in-range extrapolate beyond
	the out-range. Use `rangeMapClamped` to pin the result to the out-range.

	@param value The value to remap.
	@param inMin The lower bound of the input range.
	@param inMax The upper bound of the input range.
	@param outMin The lower bound of the output range.
	@param outMax The upper bound of the output range.
	@return `value` mapped onto `[outMin, outMax]`.
	**/
	public static inline function rangeMap(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
	}

	/**
	Like `rangeMap`, but `value` is first clamped to the in-range so the result
	always stays within `[outMin, outMax]`. Inverted in-ranges (`inMin > inMax`)
	are handled.

	@param value The value to remap.
	@param inMin One bound of the input range.
	@param inMax The other bound of the input range.
	@param outMin The lower bound of the output range.
	@param outMax The upper bound of the output range.
	@return `value` clamped to the in-range and mapped onto `[outMin, outMax]`.
	**/
	public static inline function rangeMapClamped(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		value = inMin > inMax ? clamp(value, inMax, inMin) : clamp(value, inMin, inMax);
		return rangeMap(value, inMin, inMax, outMin, outMax);
	}

	/**
	Linearly interpolate from `a` to `b` by `amount`.

	@param a The start value, returned when `amount` is `0`.
	@param b The end value, returned when `amount` is `1`.
	@param amount The interpolation factor, typically in `[0, 1]`.
	@return The interpolated value between `a` and `b`.
	**/
	public static inline function mix(a:Float, b:Float, amount:Float):Float {
		return ((1 - amount) * a) + (amount * b);
	}

	/**
	Alias of `mix`.

	@param a The start value, returned when `amount` is `0`.
	@param b The end value, returned when `amount` is `1`.
	@param amount The interpolation factor, typically in `[0, 1]`.
	@return The interpolated value between `a` and `b`.
	@see `Easings.mix`
	**/
	public static inline function lerp(a:Float, b:Float, amount:Float):Float {
		return mix(a, b, amount);
	}

	/**
	Quadratic ease-in (`t²`): accelerates from `0`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeInQuad(t:Float):Float {
		return MathMacros.pow(t, 2);
	}

	/**
	Cubic ease-in (`t³`): accelerates from `0`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeInCubic(t:Float):Float {
		return MathMacros.pow(t, 3);
	}

	/**
	Quartic ease-in (`t⁴`): accelerates from `0`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeInQuart(t:Float):Float {
		return MathMacros.pow(t, 4);
	}

	/**
	Quintic ease-in (`t⁵`): accelerates from `0`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeInQuint(t:Float):Float {
		return MathMacros.pow(t, 5);
	}

	/**
	Sine ease-in (`1 - cos(t·π/2)`): accelerates gently from `0`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeInSine(t:Float):Float {
		return 1 - Math.cos((t * Math.PI) / 2);
	}

	/**
	Quadratic ease-out (`1 - (1 - t)²`): decelerates to `1`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeOutQuad(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 2);
	}

	/**
	Cubic ease-out (`1 - (1 - t)³`): decelerates to `1`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeOutCubic(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 3);
	}

	/**
	Quartic ease-out (`1 - (1 - t)⁴`): decelerates to `1`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeOutQuart(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 4);
	}

	/**
	Quintic ease-out (`1 - (1 - t)⁵`): decelerates to `1`.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function easeOutQuint(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 5);
	}

	/**
	Smooth start-and-stop S-curve, blending quadratic ease-in and ease-out.

	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	**/
	public static inline function smoothStep(t:Float):Float {
		return mix(easeInQuad(t), easeOutQuad(t), t);
	}

	/**
	Scale `easing(t)` by the raw time `t`, i.e. `t · easing(t)`.

	Multiplying by `t` biases the curve toward `0`, a cheap way to sharpen an
	ease-in (e.g. `scale(t, easeInQuad)` behaves like `easeInCubic`).

	@param t Normalized time in `[0, 1]`.
	@param easing The easing function to apply before scaling.
	@return `t · easing(t)`.
	**/
	public static inline function scale(t:Float, easing:Float->Float):Float {
		return t * easing(t);
	}
}

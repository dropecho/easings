import {Register} from "../genes/Register.js"

/**
A small collection of easing and interpolation helpers.

The easing functions (`easeIn*`, `easeOut*`, `easeInSine`, `smoothStep`) take a
normalized time `t` in `[0, 1]` and return the eased value, also in `[0, 1]`.
The range and interpolation helpers (`clamp`, `rangeMap`, `mix`/`lerp`) are
general-purpose and accept any range.

Exposed to JavaScript as the `easings` object via `@:expose`.
*/
export const Easings = Register.global("$hxClasses")["dropecho.Easings"] = 
class Easings {
	
	/**
	Constrain `value` to the inclusive range `[min, max]`.
	
	@param value The value to clamp.
	@param min The lower bound.
	@param max The upper bound.
	@return `value` limited to `[min, max]`.
	*/
	static clamp(value, min, max) {
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
	*/
	static rangeMap(value, inMin, inMax, outMin, outMax) {
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
	*/
	static rangeMapClamped(value, inMin, inMax, outMin, outMax) {
		value = (inMin > inMax) ? Math.min(Math.max(value, inMax), inMin) : Math.min(Math.max(value, inMin), inMax);
		return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
	}
	
	/**
	Linearly interpolate from `a` to `b` by `amount`.
	
	@param a The start value, returned when `amount` is `0`.
	@param b The end value, returned when `amount` is `1`.
	@param amount The interpolation factor, typically in `[0, 1]`.
	@return The interpolated value between `a` and `b`.
	*/
	static mix(a, b, amount) {
		return (1 - amount) * a + amount * b;
	}
	
	/**
	Alias of `mix`.
	
	@param a The start value, returned when `amount` is `0`.
	@param b The end value, returned when `amount` is `1`.
	@param amount The interpolation factor, typically in `[0, 1]`.
	@return The interpolated value between `a` and `b`.
	@see `Easings.mix`
	*/
	static lerp(a, b, amount) {
		return (1 - amount) * a + amount * b;
	}
	
	/**
	Quadratic ease-in (`t²`): accelerates from `0`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeInQuad(t) {
		return t * t;
	}
	
	/**
	Cubic ease-in (`t³`): accelerates from `0`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeInCubic(t) {
		return t * t * t;
	}
	
	/**
	Quartic ease-in (`t⁴`): accelerates from `0`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeInQuart(t) {
		return t * t * t * t;
	}
	
	/**
	Quintic ease-in (`t⁵`): accelerates from `0`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeInQuint(t) {
		return t * t * t * t * t;
	}
	
	/**
	Sine ease-in (`1 - cos(t·π/2)`): accelerates gently from `0`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeInSine(t) {
		return 1 - Math.cos(t * Math.PI / 2);
	}
	
	/**
	Quadratic ease-out (`1 - (1 - t)²`): decelerates to `1`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeOutQuad(t) {
		var __pow_base = 1 - t;
		return 1 - __pow_base * __pow_base;
	}
	
	/**
	Cubic ease-out (`1 - (1 - t)³`): decelerates to `1`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeOutCubic(t) {
		var __pow_base = 1 - t;
		return 1 - __pow_base * __pow_base * __pow_base;
	}
	
	/**
	Quartic ease-out (`1 - (1 - t)⁴`): decelerates to `1`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeOutQuart(t) {
		var __pow_base = 1 - t;
		return 1 - __pow_base * __pow_base * __pow_base * __pow_base;
	}
	
	/**
	Quintic ease-out (`1 - (1 - t)⁵`): decelerates to `1`.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static easeOutQuint(t) {
		var __pow_base = 1 - t;
		return 1 - __pow_base * __pow_base * __pow_base * __pow_base * __pow_base;
	}
	
	/**
	Smooth start-and-stop S-curve, blending quadratic ease-in and ease-out.
	
	@param t Normalized time in `[0, 1]`.
	@return The eased value in `[0, 1]`.
	*/
	static smoothStep(t) {
		var __pow_base = 1 - t;
		return (1 - t) * (t * t) + t * (1 - __pow_base * __pow_base);
	}
	
	/**
	Scale `easing(t)` by the raw time `t`, i.e. `t · easing(t)`.
	
	Multiplying by `t` biases the curve toward `0`, a cheap way to sharpen an
	ease-in (e.g. `scale(t, easeInQuad)` behaves like `easeInCubic`).
	
	@param t Normalized time in `[0, 1]`.
	@param easing The easing function to apply before scaling.
	@return `t · easing(t)`.
	*/
	static scale(t, easing) {
		return t * easing(t);
	}
	static get __name__() {
		return "dropecho.Easings"
	}
	get __class__() {
		return Easings
	}
}


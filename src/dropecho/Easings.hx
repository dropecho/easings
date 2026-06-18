package dropecho;

@:expose("easings")
class Easings {
	static inline public function clamp(value:Float, min:Float, max:Float):Float {
		return Math.min(Math.max(value, min), max);
	}

	static inline public function rangeMap(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
	}

	static inline public function rangeMapClamped(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		value = inMin > inMax ? clamp(value, inMax, inMin) : clamp(value, inMin, inMax);
		return rangeMap(value, inMin, inMax, outMin, outMax);
	}

	static inline public function mix(a:Float, b:Float, amount:Float):Float {
		return ((1 - amount) * a) + (amount * b);
	}

	static inline public function lerp(a:Float, b:Float, amount:Float):Float {
		return mix(a, b, amount);
	}

	static inline public function easeIn2(t:Float):Float {
		return MathMacros.pow(t, 2);
	}

	static inline public function easeIn3(t:Float):Float {
		return MathMacros.pow(t, 3);
	}

	static inline public function easeIn4(t:Float):Float {
		return MathMacros.pow(t, 4);
	}

	static inline public function easeIn5(t:Float):Float {
		return MathMacros.pow(t, 5);
	}

	static inline public function easeOut2(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 2);
	}

	static inline public function easeOut3(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 3);
	}

	static inline public function easeOut4(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 4);
	}

	static inline public function easeOut5(t:Float):Float {
		return 1 - MathMacros.pow(1 - t, 5);
	}

	static inline public function smoothStep2(t:Float):Float {
		return mix(easeIn2(t), easeOut2(t), t);
	}

	static inline public function easeInSine(x:Float):Float {
		return 1 - Math.cos((x * Math.PI) / 2);
	}

	static inline public function scale(func:Float->Float, t:Float):Float {
		return t * func(t);
	}
}

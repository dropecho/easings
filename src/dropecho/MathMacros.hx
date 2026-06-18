package dropecho;

import haxe.macro.Expr;
import haxe.macro.Context;

class MathMacros {
	/**
	 * Raise `value` to an integer `count` power, unrolled into repeated
	 * multiplication at compile time.
	 *
	 * Compound arguments (e.g. `1 - t`) are bound to a temporary first so the
	 * expression is evaluated once instead of `count` times.
	 */
	macro static public function pow(value:Expr, count:Int):Expr {
		if (count < 1) {
			Context.error("MathMacros.pow requires an exponent of at least 1", value.pos);
		}

		// Identifiers and numeric literals are cheap and side-effect free, so we
		// repeat them inline. Anything else is bound once to avoid recomputation.
		final isSimple = switch (value.expr) {
			case EConst(CIdent(_) | CInt(_) | CFloat(_)): true;
			default: false;
		};

		if (isSimple) {
			var product = value;
			for (_ in 1...count) {
				product = macro $product * $value;
			}
			return product;
		}

		var product = macro __pow_base;
		for (_ in 1...count) {
			product = macro $product * __pow_base;
		}
		return macro {
			final __pow_base = $value;
			$product;
		};
	}
}

package;

import utest.Assert;
import dropecho.Easings;

class EasingsBenchTests extends utest.Test {
	#if (RUN_BENCHMARKS && (sys || nodejs))
	static inline final ITERATIONS = 50_000_000;
	// Derive a varying t in [0, 1) from the loop index so nothing constant-folds.
	static inline final MASK = 0xFFFF;
	static inline final INV = 1.0 / 0xFFFF;

	inline function input(i:Int):Float {
		return (i & MASK) * INV;
	}

	function report(name:String, time:Float, acc:Float) {
		var perCall = Math.round(time / ITERATIONS * 1e9 * 1000) / 1000;
		trace('$name\n total: ${time}s  per-call: ${perCall}ns  (acc=$acc)');
	}

	// Establishes loop + input overhead so the figures below are read as the
	// marginal cost of the easing call itself.
	public function test_a_baseline() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += input(i);
		report("baseline (loop + input)", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_b_clamp() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.clamp(input(i) * 2 - 0.5, 0, 1);
		report("clamp", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_c_rangeMap() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.rangeMap(input(i), 0, 1, 0, 100);
		report("rangeMap", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_d_rangeMapClamped() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.rangeMapClamped(input(i) * 2 - 0.5, 0, 1, 0, 100);
		report("rangeMapClamped", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_e_mix() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.mix(0, 100, input(i));
		report("mix", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_f_easeIn2() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.easeIn2(input(i));
		report("easeIn2", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_g_easeIn5() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.easeIn5(input(i));
		report("easeIn5", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_h_easeOut2() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.easeOut2(input(i));
		report("easeOut2", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_i_easeOut5() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.easeOut5(input(i));
		report("easeOut5", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_j_smoothStep2() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.smoothStep2(input(i));
		report("smoothStep2", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	public function test_k_easeInSine() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.easeInSine(input(i));
		report("easeInSine", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}

	// scale() takes a function value, so the inner call cannot be inlined — this
	// measures the dynamic-dispatch cost relative to the inlined eases above.
	public function test_l_scale() {
		var acc = 0.0;
		var start = Sys.cpuTime();
		for (i in 0...ITERATIONS)
			acc += Easings.scale(Easings.easeIn2, input(i));
		report("scale(easeIn2)", Sys.cpuTime() - start, acc);
		Assert.isTrue(acc > 0);
	}
	#end
}

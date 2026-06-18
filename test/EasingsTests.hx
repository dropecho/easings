package;

import utest.Assert;
import dropecho.Easings;

class EasingsTests extends utest.Test {
	public function test_clamp_within() {
		Assert.equals(0.5, Easings.clamp(0.5, 0, 1));
	}

	public function test_clamp_below_min() {
		Assert.equals(0.0, Easings.clamp(-1, 0, 1));
	}

	public function test_clamp_above_max() {
		Assert.equals(1.0, Easings.clamp(2, 0, 1));
	}

	public function test_lerp_matches_mix() {
		Assert.equals(Easings.mix(0, 10, 0.3), Easings.lerp(0, 10, 0.3));
	}

	public function test_easeIn2_endpoints() {
		Assert.equals(0.0, Easings.easeIn2(0));
		Assert.equals(1.0, Easings.easeIn2(1));
	}

	public function test_easeOut2_endpoints() {
		Assert.equals(0.0, Easings.easeOut2(0));
		Assert.equals(1.0, Easings.easeOut2(1));
	}

	public function test_smoothStep2_midpoint() {
		Assert.equals(0.5, Easings.smoothStep2(0.5));
	}

	public function test_easeInSine_endpoints() {
		Assert.floatEquals(0.0, Easings.easeInSine(0));
		Assert.floatEquals(1.0, Easings.easeInSine(1));
	}

	public function test_scale_applies_func() {
		// scale(f, t) = t * f(t); with easeIn2 that is t * t^2 == t^3 == easeIn3(t).
		Assert.equals(Easings.easeIn3(0.5), Easings.scale(Easings.easeIn2, 0.5));
	}
}

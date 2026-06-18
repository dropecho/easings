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

	public function test_easeInQuad_endpoints() {
		Assert.equals(0.0, Easings.easeInQuad(0));
		Assert.equals(1.0, Easings.easeInQuad(1));
	}

	public function test_easeOutQuad_endpoints() {
		Assert.equals(0.0, Easings.easeOutQuad(0));
		Assert.equals(1.0, Easings.easeOutQuad(1));
	}

	public function test_smoothStep_midpoint() {
		Assert.equals(0.5, Easings.smoothStep(0.5));
	}

	public function test_easeInSine_endpoints() {
		Assert.floatEquals(0.0, Easings.easeInSine(0));
		Assert.floatEquals(1.0, Easings.easeInSine(1));
	}

	public function test_scale_applies_easing() {
		// scale(t, f) = t * f(t); with easeInQuad that is t * t^2 == t^3 == easeInCubic(t).
		Assert.equals(Easings.easeInCubic(0.5), Easings.scale(0.5, Easings.easeInQuad));
	}
}

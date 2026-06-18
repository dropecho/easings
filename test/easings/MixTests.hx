package easings;

import utest.Assert;
import dropecho.Easings;

class MixTests extends utest.Test {
	public function test_mix_linear() {
		Assert.equals(1.0, Easings.mix(0, 1, 1));
	}

	public function test_mix_weight_half() {
		Assert.equals(0.5, Easings.mix(0, 1, 0.5));
	}

	public function test_mix_weight_quarter() {
		Assert.equals(0.25, Easings.mix(0, 1, 0.25));
	}
}

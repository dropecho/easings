package easings;

import utest.Assert;
import dropecho.Easings;

class RangeMapClampedTests extends utest.Test {
	public function test_rangeMapClamped_bigger_to_smaller() {
		Assert.equals(0.5, Easings.rangeMapClamped(1, 0, 1, 0, 0.5));
	}

	public function test_rangeMapClamped_smaller_to_bigger() {
		Assert.equals(1.0, Easings.rangeMapClamped(0.5, 0, 0.5, 0, 1));
	}

	public function test_rangeMapClamped_invert() {
		Assert.equals(0.0, Easings.rangeMapClamped(1, 0, 1, 1, 0));
	}

	public function test_rangeMapClamped_invert_non_end() {
		Assert.equals(0.4, Easings.rangeMapClamped(0.6, 0, 1, 1, 0));
	}

	public function test_rangeMapClamped_clamps_below_range() {
		// value below inMin is clamped, so output pins to outMin.
		Assert.equals(0.0, Easings.rangeMapClamped(-5, 0, 1, 0, 1));
	}

	public function test_rangeMapClamped_clamps_above_range() {
		Assert.equals(1.0, Easings.rangeMapClamped(5, 0, 1, 0, 1));
	}
}

package easings;

import utest.Assert;
import dropecho.Easings;

class RangeMapTests extends utest.Test {
	public function test_rangeMap_bigger_to_smaller() {
		Assert.equals(0.5, Easings.rangeMap(1, 0, 1, 0, 0.5));
	}

	public function test_rangeMap_smaller_to_bigger() {
		Assert.equals(1.0, Easings.rangeMap(0.5, 0, 0.5, 0, 1));
	}

	public function test_rangeMap_invert() {
		Assert.equals(0.0, Easings.rangeMap(1, 0, 1, 1, 0));
	}

	public function test_rangeMap_invert_non_end() {
		Assert.equals(0.4, Easings.rangeMap(0.6, 0, 1, 1, 0));
	}
}

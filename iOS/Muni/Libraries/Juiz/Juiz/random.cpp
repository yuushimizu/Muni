#include "juiz/random.h"
#include <math.h>

namespace juiz {
	namespace random {
		double next_double(Random &random, const double bound) {
			return random.next() * bound;
		}

		double next_double(Random &random, const double min, const double bound) {
			return min + random.next() * (bound - min);
		}

		int next_int(Random &random, const int bound) {
			return random.next() * bound;
		}

		int next_int(Random &random, const int min, const int bound) {
			return min + random.next() * (bound - min);
		}

		bool next_bool(Random &random) {
			return next_int(random, 2) == 0;
		}

		double next_radian(Random &random) {
			return next_double(random, M_PI * 2);
		}
	}
}
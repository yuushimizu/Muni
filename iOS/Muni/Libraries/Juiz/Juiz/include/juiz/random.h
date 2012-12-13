#ifndef __Juiz__random__
#define __Juiz__random__

#include "random/MersenneTwister.h"

namespace juiz {
	namespace random {
		typedef MersenneTwister Random;
		double next_double(Random &random, const double bound);
		double next_double(Random &random, const double min, const double bound);
		int next_int(Random &random, const int bound);
		int next_int(Random &random, const int min, const int bound);
		bool next_bool(Random &random);
		double next_radian(Random &random);
	}
}

#endif /* defined(__Juiz__random__) */

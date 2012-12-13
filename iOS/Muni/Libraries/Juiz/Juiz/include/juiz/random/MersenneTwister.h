#ifndef __Juiz__random__MersenneTwister__
#define __Juiz__random__MersenneTwister__

#include "dSFMT/dSFMT.h"

namespace juiz {
	namespace random {
		class MersenneTwister {
		private:
			dsfmt_t dsfmt_;
		public:
			explicit MersenneTwister(const int seed);
			double next();
		};
	}
}

#endif /* defined(__Juiz__random__MersenneTwister__) */

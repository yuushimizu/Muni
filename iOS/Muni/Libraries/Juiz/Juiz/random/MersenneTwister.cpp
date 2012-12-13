#include "juiz/random/MersenneTwister.h"

namespace juiz {
	namespace random {
		MersenneTwister::MersenneTwister(const int seed) {
			dsfmt_init_gen_rand(&this->dsfmt_, seed);
		}

		double MersenneTwister::next() {
			return dsfmt_genrand_close_open(&this->dsfmt_);
		}
	}
}

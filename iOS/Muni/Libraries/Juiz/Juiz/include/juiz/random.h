#ifndef __Juiz__random__
#define __Juiz__random__

#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/Size.h"
#include "juiz/coordinate/Direction.h"
#include <random>

namespace juiz {
	namespace random {
		template<typename Engine>
		int next_int(Engine &engine, const int min, const int limit) {
			return std::uniform_int_distribution<>(min, limit -1)(engine);
		}
		
		template <typename Engine>
		int next_int(Engine &engine, const int limit) {
			return next_int(engine, 0, limit);
		}
		
		template<typename Engine>
		double next_double(Engine &engine, const double min, const double limit) {
			return std::uniform_real_distribution<>(min, limit)(engine);
		}
		
		template<typename Engine>
		double next_double(Engine &engine, const double limit) {
			return next_double(engine, 0, limit);
		}
		
		template<typename Engine>
		double next_bool(Engine &engine) {
			return next_int(engine, 2) == 0;
		}
		
		template<typename Engine>
		coordinate::Point next_point(Engine &engine, const coordinate::Size &size) {
			return coordinate::Point(next_double(engine, size.width()), next_double(engine, size.height()));
		}
		
		template<typename Engine>
		double next_angle(Engine &engine) {
			return next_double(engine, M_PI * 2);
		}
		
		template<typename Engine>
		coordinate::Direction next_direction(Engine &engine) {
			return coordinate::Direction(next_angle(engine));
		}
	}
}

#endif

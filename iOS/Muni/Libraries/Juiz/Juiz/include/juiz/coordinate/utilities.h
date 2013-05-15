#ifndef __Juiz__coordinate__utilities__
#define __Juiz__coordinate__utilities__

#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/Direction.h"
#include "juiz/coordinate/Vector.h"

namespace juiz {
	namespace coordinate {
		double invert(const double source, const double origin);
		Direction direction(const Point &start, const Point &end);
		Vector vector(const Point&start, const Point &end);
	}
}

#endif

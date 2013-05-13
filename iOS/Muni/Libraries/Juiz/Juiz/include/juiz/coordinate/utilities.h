#ifndef __Juiz__coordinate__utilities__
#define __Juiz__coordinate__utilities__

#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/Direction.h"
#include "juiz/coordinate/Vector.h"

namespace juiz {
	namespace coordinate {
		Direction direction(const Point &start, const Point &end);
		Vector vector(const Point&start, const Point &end);
		Point add_vector(const Point &point, const Vector &vector);
		Point add_vector(Point &&point, const Vector &vector);
	}
}

#endif

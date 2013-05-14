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
		Point add_vector(const Point &point, const Vector &vector);
		Point add_vector(Point &&point, const Vector &vector);
		Point rotate_clockwise(const Point &point, const Point &origin, const double angle);
		Point rotate_clockwise(const Point &point, Point &&origin, const double angle);
		Point rotate_counterclockwise(const Point &point, const Point &origin, const double angle);
		Point rotate_counterclockwise(const Point &point, Point &&origin, const double angle);
		Point invert(const Point &point, const Point &origin);
		Point invert(Point &&point, const Point &origin);
		Point invert(const Point &point, Point &&origin);
	}
}

#endif

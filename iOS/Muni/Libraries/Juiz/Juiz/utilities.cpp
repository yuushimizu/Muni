#include "juiz/coordinate/utilities.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		Direction direction(const Point &start, const Point &end) {
			return Direction(atan2(end.x() - start.x(), end.y() - start.y()));
		}
		
		Vector vector(const Point &start, const Point &end) {
			return Vector(direction(start, end), distance(start, end));
		}

		Point add_vector(const Point &point, const Vector &vector) {
			return Point(point.x() + x(vector), point.y() + y(vector));
		}
		
		Point add_vector(Point &&point, const Vector &vector) {
			point.x(point.x() + x(vector));
			point.y(point.y() + y(vector));
			return point;
		}
	}
}

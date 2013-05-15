#include "juiz/coordinate/utilities.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		double invert(const double source, const double origin) {
			return origin - (source - origin);
		}
		
		Direction direction(const Point &start, const Point &end) {
			return Direction(atan2(end.x() - start.x(), end.y() - start.y()));
		}
		
		Vector vector(const Point &start, const Point &end) {
			return Vector(direction(start, end), distance(start, end));
		}
	}
}

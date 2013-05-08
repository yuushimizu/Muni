#include "juiz/coordinate/utilities.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		const Vector vector(const Point &start, const Point &end) {
			return vector(end.x() - start.x(), end.y() - start.y());
		}
		
		const Point add_vector(const Point &point, const Vector &vector) {
			return Point(point.x() + x(vector), point.y() + y(vector));
		}
	}
}

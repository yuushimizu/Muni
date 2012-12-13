#ifndef __Juiz__coordinate__
#define __Juiz__coordinate__

#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/PointInterval.h"
#include "juiz/coordinate/Vector.h"
#include "juiz/coordinate/Size.h"

namespace juiz {
	namespace coordinate {
		const PointInterval point_interval_of_points(const Point &source, const Point &destination);
		const Point add_point_interval_to_point(const Point &point, const PointInterval &point_interval);
		const PointInterval point_interval_from_vector(const Vector &vector);
		const Vector vector_from_point_interval(const PointInterval &point_interval);
		const double invert_angle(const double angle);
	}
}

#endif /* defined(__Juiz__coordinate__) */

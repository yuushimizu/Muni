#include "juiz/coordinate.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		const PointInterval point_interval_of_points(const Point &source, const Point &destination) {
			return PointInterval(destination.x() - source.x(), destination.y() - source.y());
		}
		
		const Point add_point_interval_to_point(const Point &point, const PointInterval &point_interval) {
			return Point(point.x() + point_interval.x(), point.y() + point_interval.y());
		}
		
		const PointInterval point_interval_from_vector(const Vector &vector) {
			return PointInterval(vector.magnitude() * sin(vector.direction()), vector.magnitude() * cos(vector.direction()));
		}
		
		const Vector vector_from_point_interval(const PointInterval &point_interval) {
			return Vector(angle_of_point_interval(point_interval), distance_of_point_interval(point_interval));
		}
		
		const double invert_angle(const double angle) {
			return angle < M_PI ? angle + M_PI : angle - M_PI;
		}
	}
}

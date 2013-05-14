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
		
		Point add_vector(const Point &point, const Vector &vector) {
			return Point(point.x() + x(vector), point.y() + y(vector));
		}
		
		Point add_vector(Point &&point, const Vector &vector) {
			return with_y(with_x(std::move(point), point.x() + x(vector)), point.y() + y(vector));
		}
		
		Point rotate_clockwise(const Point &point, const Point &origin, const double angle) {
			return add_vector(origin, rotate_clockwise(vector(origin, point), angle));
		}
		
		Point rotate_clockwise(const Point &point, Point &&origin, const double angle) {
			return add_vector(std::move(origin), rotate_clockwise(vector(origin, point), angle));
		}
		
		Point rotate_counterclockwise(const Point &point, const Point &origin, const double angle) {
			return rotate_clockwise(point, origin, -angle);
		}
		
		Point rotate_counterclockwise(const Point &point, Point &&origin, const double angle) {
			return rotate_clockwise(point, std::move(origin), -angle);
		}
		
		Point invert(const Point &point, const Point &origin) {
			return Point(invert(point.x(), origin.x()), invert(point.y(), origin.y()));
		}
		
		Point invert(Point &&point, const Point &origin) {
			return with_y(with_x(std::move(point), invert(point.x(), origin.x())), invert(point.y(), origin.y()));
		}
		
		Point invert(const Point &point, Point &&origin) {
			return with_y(with_x(std::move(origin), invert(point.x(), origin.x())), invert(point.y(), origin.y()));
		}
	}
}

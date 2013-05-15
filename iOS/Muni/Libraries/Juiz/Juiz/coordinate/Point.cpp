#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/Vector.h"
#include "juiz/coordinate/utilities.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		Point::Point(const double x, const double y) : x_(x), y_(y) {
		}
	
		Point::Point() : Point(0, 0) {
		}
		
		double Point::x() const {
			return this->x_;
		}
		
		Point Point::x(const double x) const {
			Point newPoint(*this);
			newPoint.x_ = x;
			return newPoint;
		}
		
		double Point::y() const {
			return this->y_;
		}
		
		Point Point::y(const double y) const {
			Point newPoint(*this);
			newPoint.y_ = y;
			return newPoint;
		}
		
		bool operator==(const Point &lhs, const Point &rhs) {
			return lhs.x() == rhs.x() && lhs.y() == rhs.y();
		}
		
		bool operator!=(const Point &lhs, const Point &rhs) {
			return !(lhs == rhs);
		}
		
		Point rotate_clockwise(const Point &point, const Point &origin, const double angle) {
			return add_vector(origin, rotate_clockwise(vector(origin, point), angle));
		}
		
		Point rotate_counterclockwise(const Point &point, const Point &origin, const double angle) {
			return rotate_clockwise(point, origin, -angle);
		}
		
		Point invert(const Point &point, const Point &origin) {
			return Point(invert(point.x(), origin.x()), invert(point.y(), origin.y()));
		}

		Point add_vector(const Point &point, const Vector &vector) {
			return Point(point.x() + x(vector), point.y() + y(vector));
		}
		
		Point move_to(const Point &start, const Point &destination, const double max_distance) {
			const Vector vector_to_destination = vector(start, destination);
			if (vector_to_destination.magnitude() <= max_distance) return destination;
			return add_vector(start, vector_to_destination.magnitude(max_distance));
		}
		
		double distance(const Point &start, const Point &end) {
			return sqrt(pow(end.x() - start.x(), 2) + pow(end.y() - start.y(), 2));
		}
	}
}
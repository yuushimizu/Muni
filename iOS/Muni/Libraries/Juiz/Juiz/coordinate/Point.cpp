#include "juiz/coordinate/Point.h"
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
		
		void Point::x(const double x) {
			this->x_ = x;
		}
		
		double Point::y() const {
			return this->y_;
		}
		
		void Point::y(const double y) {
			this->y_ = y;
		}
		
		bool operator==(const Point &lhs, const Point &rhs) {
			return lhs.x() == rhs.x() && lhs.y() == rhs.y();
		}
		
		bool operator!=(const Point &lhs, const Point &rhs) {
			return !(lhs == rhs);
		}
		
		Point with_x(const Point &point, const double x) {
			return Point(x, point.y());
		}
		
		Point with_x(Point &&point, const double x) {
			point.x(x);
			return point;
		}
		
		Point with_y(const Point &point, const double y) {
			return Point(point.x(), y);
		}
		
		Point with_y(Point &&point, const double y) {
			point.y(y);
			return point;
		}
		
		double distance(const Point &start, const Point &end) {
			return sqrt(pow(end.x() - start.x(), 2) + pow(end.y() - start.y(), 2));
		}
	}
}
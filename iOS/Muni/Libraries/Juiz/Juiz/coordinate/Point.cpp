#include "juiz/coordinate/Point.h"

namespace juiz {
	namespace coordinate {
		Point::Point(const double x, const double y) : x_(x), y_(y) {
		}
	
		Point::Point() : Point(0, 0) {
		}
		
		const double Point::x() const {
			return this->x_;
		}
		
		const double Point::y() const {
			return this->y_;
		}
		
		const bool operator==(const Point &lhs, const Point &rhs) {
			return lhs.x() == rhs.x() && lhs.y() == rhs.y();
		}
		
		const bool operator!=(const Point &lhs, const Point &rhs) {
			return !(lhs == rhs);
		}
	}
}
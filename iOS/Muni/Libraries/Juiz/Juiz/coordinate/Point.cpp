#include "juiz/coordinate/Point.h"

namespace juiz {
	namespace coordinate {
		Point::Point() : x_(0), y_(0) {
		}
		
		Point::Point(const double x, const double y) : x_(x), y_(y) {
		}
	
		const double Point::x() const {
			return this->x_;
		}
		
		const double Point::x(const double x) {
			return this->x_ = x;
		}
		
		const double Point::y() const {
			return this->y_;
		}
		
		const double Point::y(const double y) {
			return this->y_ = y;
		}
		
		const bool operator==(const Point &lhs, const Point &rhs) {
			return lhs.x() == rhs.x() && lhs.y() == rhs.y();
		}
		
		const bool operator!=(const Point &lhs, const Point &rhs) {
			return !(lhs == rhs);
		}
	}
}
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
		
		double distance(const Point &start, const Point &end) {
			return sqrt(pow(end.x() - start.x(), 2) + pow(end.y() - start.y(), 2));
		}
	}
}
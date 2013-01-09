#include "juiz/coordinate/PointInterval.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		PointInterval::PointInterval(const double x, const double y) : x_(x), y_(y) {
		}
		
		PointInterval::PointInterval() : PointInterval(0, 0) {
		}
		
		const double PointInterval::x() const {
			return this->x_;
		}
		
		const double PointInterval::x(const double x) {
			return this->x_ = x;
		}
		
		const double PointInterval::y() const {
			return this->y_;
		}
		
		const double PointInterval::y(const double y) {
			return this->y_ = y;
		}
		
		const bool operator==(const PointInterval &lhs, const PointInterval &rhs) {
			return lhs.x() == rhs.x() && lhs.y() == rhs.y();
		}
		
		const bool operator!=(const PointInterval &lhs, const PointInterval &rhs) {
			return !(lhs == rhs);
		}
		
		const double angle_of_point_interval(const PointInterval &point_interval) {
			return atan2(point_interval.x(), point_interval.y());
		}
		
		const double distance_of_point_interval(const PointInterval &point_interval) {
			return sqrt(point_interval.x() * point_interval.x() + point_interval.y() * point_interval.y());
		}
	}
}
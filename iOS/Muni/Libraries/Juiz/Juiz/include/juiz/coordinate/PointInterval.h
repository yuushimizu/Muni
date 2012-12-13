#ifndef __Juiz__coordinate__PointInterval__
#define __Juiz__coordinate__PointInterval__

namespace juiz {
	namespace coordinate {
		class Point;
		class PointInterval {
		private:
			double x_;
			double y_;
		public:
			PointInterval();
			PointInterval(const double x, const double y);
			const double x() const;
			const double x(const double x);
			const double y() const;
			const double y(const double y);
		};
		const bool operator ==(const PointInterval &lhs, const PointInterval &rhs);
		const bool operator !=(const PointInterval &lhs, const PointInterval &rhs);
		const double angle_of_point_interval(const PointInterval &point_interval);
		const double distance_of_point_interval(const PointInterval &point_interval);
	}
}

#endif /* defined(__Juiz__coordinate__PointInterval__) */

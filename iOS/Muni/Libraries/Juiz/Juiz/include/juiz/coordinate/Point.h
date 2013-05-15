#ifndef __Juiz__coordinate__Point__
#define __Juiz__coordinate__Point__

namespace juiz {
	namespace coordinate {
		class Vector;
		class Point {
		private:
			double x_;
			double y_;
		public:
			Point(const double x, const double y);
			Point();
			double x() const;
			Point x(const double x) const;
			double y() const;
			Point y(const double y) const;
		};
		bool operator==(const Point &lhs, const Point &rhs);
		bool operator!=(const Point &lhs, const Point &rhs);
		Point rotate_clockwise(const Point &point, const Point &origin, const double angle);
		Point rotate_counterclockwise(const Point &point, const Point &origin, const double angle);
		Point invert(const Point &point, const Point &origin);
		Point add_vector(const Point &point, const Vector &vector);
		double distance(const Point &start, const Point &end);
	}
}

#endif

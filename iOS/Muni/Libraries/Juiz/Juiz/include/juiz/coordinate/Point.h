#ifndef __Juiz__coordinate__Point__
#define __Juiz__coordinate__Point__

namespace juiz {
	namespace coordinate {
		class Point {
		private:
			double x_;
			double y_;
		public:
			Point(const double x, const double y);
			Point();
			double x() const;
			void x(const double x);
			double y() const;
			void y(const double y);
		};
		bool operator==(const Point &lhs, const Point &rhs);
		bool operator!=(const Point &lhs, const Point &rhs);
		Point with_x(const Point &point, const double x);
		Point with_x(Point &&point, const double x);
		Point with_y(const Point &point, const double y);
		Point with_y(Point &&point, const double y);
		double distance(const Point &start, const Point &end);
	}
}

#endif

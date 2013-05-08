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
			const double x() const;
			const double y() const;
		};
		const bool operator==(const Point &lhs, const Point &rhs);
		const bool operator!=(const Point &lhs, const Point &rhs);
	}
}

#endif

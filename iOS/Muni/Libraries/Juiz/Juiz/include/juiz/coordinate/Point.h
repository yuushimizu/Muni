#ifndef __Juiz__coordinate__Point__
#define __Juiz__coordinate__Point__

namespace juiz {
	namespace coordinate {
		class Point {
		private:
			double x_;
			double y_;
		public:
			Point();
			Point(const double x, const double y);
			const double x() const;
			const double x(const double x);
			const double y() const;
			const double y(const double y);
		};
		const bool operator==(const Point &lhs, const Point &rhs);
		const bool operator!=(const Point &lhs, const Point &rhs);
	}
}

#endif /* defined(__Juiz__coordinate__Point__) */

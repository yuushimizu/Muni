#ifndef __Juiz__coordinate__Direction__
#define __Juiz__coordinate__Direction__

#include <math.h>
#include <utility>

namespace juiz {
	namespace coordinate {
		class Direction {
		private:
			double clockwise_angle_with_above_;
		public:
			explicit Direction(const double clockwise_angle_with_above);
			Direction();
			double clockwise_angle_with_above() const;
			Direction clockwise_angle_with_above(const double clockwise_angle_with_above) const;
		};
		bool operator==(const Direction &lhs, const Direction &rhs);
		bool operator!=(const Direction &lhs, const Direction &rhs);
		Direction rotate_clockwise(const Direction &direction, const double angle);
		Direction rotate_counterclockwise(const Direction &direction, const double angle);
		Direction invert(const Direction &direction);
		double clockwise_angle(const Direction &start, const Direction &end);
		double counterclockwise_angle(const Direction &start, const Direction &end);
		bool clockwise_angle_is_small(const Direction &start, const Direction &end);
		namespace directions {
			extern const Direction ABOVE;
			extern const Direction BELOW;
			extern const Direction RIGHT;
			extern const Direction LEFT;
		}
	}
}

#endif

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
			void clockwise_angle_with_above(const double clockwise_angle_with_above);
		};
		bool operator==(const Direction &lhs, const Direction &rhs);
		bool operator!=(const Direction &lhs, const Direction &rhs);
		Direction with_clockwise_angle_with_above(const Direction &direction, const double clockwise_angle_with_above);
		Direction with_clockwise_angle_with_above(Direction &&direction, const double clockwise_angle_with_above);
		Direction rotate_clockwise(const Direction &direction, const double angle);
		Direction rotate_clockwise(Direction &&direction, const double angle);
		Direction rotate_counterclockwise(const Direction &direction, const double angle);
		Direction rotate_counterclockwise(Direction &&direction, const double angle);
		Direction invert(const Direction &direction);
		Direction invert(Direction &&direction);
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

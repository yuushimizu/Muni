#ifndef __Juiz__coordinate__Direction__
#define __Juiz__coordinate__Direction__

#include <math.h>

namespace juiz {
	namespace coordinate {
		class Direction {
		private:
			double clockwise_angle_with_above_;
		public:
			explicit Direction(const double clockwise_angle_with_above);
			Direction();
			const double clockwise_angle_with_above() const;
		};
		const bool operator==(const Direction &lhs, const Direction &rhs);
		const bool operator!=(const Direction &lhs, const Direction &rhs);
		const Direction rotate_clockwise(const Direction &direction, const double angle);
		const Direction rotate_counterclockwise(const Direction &direction, const double angle);
		const Direction invert(const Direction &direction);
		const double clockwise_angle(const Direction &start, const Direction &end);
		const double counterclockwise_angle(const Direction &start, const Direction &end);
		const bool clockwise_angle_is_small(const Direction &start, const Direction &end);
		namespace direction {
			extern const Direction ABOVE;
			extern const Direction BELOW;
			extern const Direction RIGHT;
			extern const Direction LEFT;
		}
	}
}

#endif

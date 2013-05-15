#include "juiz/coordinate/Direction.h"
#include <utility>

namespace juiz {
	namespace coordinate {
		static double fix_angle_range(const double angle) {
			double fixed_angle = angle;
			while (fixed_angle < 0) fixed_angle += M_PI * 2;
			while (fixed_angle > M_PI * 2) fixed_angle -= M_PI * 2;
			return fixed_angle;
		}
		
		Direction::Direction(const double clockwise_angle_with_above) : clockwise_angle_with_above_(fix_angle_range(clockwise_angle_with_above)) {
		}
		
		Direction::Direction() : Direction(0) {
		}
		
		double Direction::clockwise_angle_with_above() const {
			return this->clockwise_angle_with_above_;
		}
		
		Direction Direction::clockwise_angle_with_above(const double clockwise_angle_with_above) const {
			Direction newDirection(*this);
			newDirection.clockwise_angle_with_above_ = fix_angle_range(clockwise_angle_with_above);
			return newDirection;
		}
		
		bool operator==(const Direction &lhs, const Direction &rhs) {
			return lhs.clockwise_angle_with_above() == rhs.clockwise_angle_with_above();
		}
		
		bool operator!=(const Direction &lhs, const Direction &rhs) {
			return !(lhs == rhs);
		}
		
		Direction rotate_clockwise(const Direction &direction, const double angle) {
			return direction.clockwise_angle_with_above(direction.clockwise_angle_with_above() + angle);
		}
		
		Direction rotate_counterclockwise(const Direction &direction, const double angle) {
			return rotate_clockwise(direction, -angle);
		}
		
		Direction invert(const Direction &direction) {
			return rotate_clockwise(direction, M_PI);
		}
		
		double clockwise_angle(const Direction &start, const Direction &end) {
			return fix_angle_range(end.clockwise_angle_with_above() - start.clockwise_angle_with_above());
		}
		
		double counterclockwise_angle(const Direction &start, const Direction &end) {
			return clockwise_angle(end, start);
		}
		
		bool clockwise_angle_is_small(const Direction &start, const Direction &end) {
			return clockwise_angle(start, end) < M_PI;
		}
		
		namespace directions {
			const Direction ABOVE(0);
			const Direction RIGHT(M_PI_2);
			const Direction BELOW(M_PI);
			const Direction LEFT(M_PI + M_PI_2);
		}
	}
}

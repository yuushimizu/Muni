#include "juiz/coordinate/Vector.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		Vector::Vector(const Direction direction, const double magnitude) : direction_(direction), magnitude_(magnitude) {
		}
		
		Vector::Vector() : Vector(direction::ABOVE, 0) {
		}
		
		const Direction Vector::direction() const {
			return this->direction_;
		}
		
		const double Vector::magnitude() const {
			return this->magnitude_;
		}
		
		const bool operator ==(const Vector &lhs, const Vector &rhs) {
			return lhs.direction() == rhs.direction() && lhs.magnitude() == rhs.magnitude();
		}
		
		const bool operator !=(const Vector &lhs, const Vector &rhs) {
			return !(lhs == rhs);
		}
		
		const Vector operator +(const Vector &vector) {
			return vector;
		}
		
		const Vector operator +(const Vector &lhs, const Vector &rhs) {
			return vector(x(lhs) + x(rhs), y(lhs) + y(rhs));
		}
		
		const Vector operator -(const Vector &vector) {
			return Vector(invert(vector.direction()), vector.magnitude());
		}
		
		const Vector operator -(const Vector &lhs, const Vector &rhs) {
			return lhs + -rhs;
		}
		
		const Vector operator *(const Vector &lhs, const double &rhs) {
			return Vector(lhs.direction(), lhs.magnitude() * rhs);
		}
		
		const Vector vector(const double x, const double y) {
			return Vector(Direction(atan2(x, y)), sqrt(x * x + y * y));
		}
		
		const double x(const Vector &vector) {
			return vector.magnitude() * sin(vector.direction().clockwise_angle_with_above());
		}
		
		const double y(const Vector &vector) {
			return vector.magnitude() * cos(vector.direction().clockwise_angle_with_above());
		}
	}
}
#include "juiz/coordinate/Vector.h"
#include "juiz/coordinate/PointInterval.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		Vector::Vector() : direction_(0), magnitude_(0) {
		}
		
		Vector::Vector(const double direction, const double magnitude) : direction_(direction), magnitude_(magnitude) {
		}
		
		const double Vector::direction() const {
			return this->direction_;
		}
		
		const double Vector::direction(const double direction) {
			return this->direction_ = direction;
		}
		
		const double Vector::magnitude() const {
			return this->magnitude_;
		}
		
		const double Vector::magnitude(const double magnitude) {
			return this->magnitude_ = magnitude;
		}
		
		const bool operator==(const Vector &lhs, const Vector &rhs) {
			return lhs.direction() == rhs.direction() && lhs.magnitude() == rhs.magnitude();
		}
		
		const bool operator!=(const Vector &lhs, const Vector &rhs) {
			return !(lhs == rhs);
		}
	}
}
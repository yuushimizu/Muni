#include "juiz/coordinate/Vector.h"
#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/utilities.h"
#include <math.h>
#include <utility>

namespace juiz {
	namespace coordinate {
		Vector::Vector(const Direction &direction, const double magnitude) : direction_(direction), magnitude_(magnitude) {
		}
		
		Vector::Vector() : Vector(directions::ABOVE, 0) {
		}
		
		Direction Vector::direction() const {
			return this->direction_;
		}
		
		Vector Vector::direction(const Direction &direction) const {
			Vector newVector(*this);
			newVector.direction_ = direction;
			return newVector;
		}
		
		double Vector::magnitude() const {
			return this->magnitude_;
		}
		
		Vector Vector::magnitude(const double magnitude) const {
			Vector newVector(*this);
			newVector.magnitude_ = magnitude;
			return newVector;
		}
		
		bool operator ==(const Vector &lhs, const Vector &rhs) {
			return lhs.direction() == rhs.direction() && lhs.magnitude() == rhs.magnitude();
		}
		
		bool operator !=(const Vector &lhs, const Vector &rhs) {
			return !(lhs == rhs);
		}
		
		Vector operator +(const Vector &vector) {
			return vector;
		}
		
		Vector operator +(const Vector &lhs, const Vector &rhs) {
			return vector(Point(0, 0), Point(x(lhs) + x(rhs), y(lhs) + y(rhs)));
		}
		
		Vector operator -(const Vector &vector) {
			return invert(vector);
		}
		
		Vector operator -(const Vector &lhs, const Vector &rhs) {
			return lhs + -rhs;
		}
		
		Vector operator *(const Vector &lhs, const double rhs) {
			return lhs.magnitude(lhs.magnitude() * rhs);
		}
		
		Vector rotate_clockwise(const Vector &vector, const double angle) {
			return vector.direction(rotate_clockwise(vector.direction(), angle));
		}
		
		Vector rotate_counterclockwise(const Vector &vector, const double angle) {
			return vector.direction(rotate_counterclockwise(vector.direction(), angle));
		}
		
		Vector invert(const Vector &vector) {
			return vector.direction(invert(vector.direction()));
		}

		double x(const Vector &vector) {
			return vector.magnitude() * sin(vector.direction().clockwise_angle_with_above());
		}
		
		double y(const Vector &vector) {
			return vector.magnitude() * cos(vector.direction().clockwise_angle_with_above());
		}
	}
}
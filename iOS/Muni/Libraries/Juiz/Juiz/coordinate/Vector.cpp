#include "juiz/coordinate/Vector.h"
#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/utilities.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		Vector::Vector(const Direction &direction, const double magnitude) : direction_(direction), magnitude_(magnitude) {
		}
		
		Vector::Vector() : Vector(directions::ABOVE, 0) {
		}
		
		Direction Vector::direction() const {
			return this->direction_;
		}
		
		void Vector::direction(const Direction &direction) {
			this->direction_ = direction;
		}
		
		double Vector::magnitude() const {
			return this->magnitude_;
		}
		
		void Vector::magnitude(const double magnitude) {
			this->magnitude_ = magnitude;
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
			return Vector(invert(vector.direction()), vector.magnitude());
		}
		
		Vector operator -(Vector &&vector) {
			vector.direction(invert(vector.direction()));
			return vector;
		}
		
		Vector operator *(const Vector &lhs, const double rhs) {
			return Vector(lhs.direction(), lhs.magnitude() * rhs);
		}
		
		Vector operator *(Vector &&lhs, const double rhs) {
			lhs.magnitude(lhs.magnitude() * rhs);
			return lhs;
		}

		double x(const Vector &vector) {
			return vector.magnitude() * sin(vector.direction().clockwise_angle_with_above());
		}
		
		double y(const Vector &vector) {
			return vector.magnitude() * cos(vector.direction().clockwise_angle_with_above());
		}
	}
}
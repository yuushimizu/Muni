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
		
		Vector rotate_clockwise(const Vector &vector, const double angle) {
			return with_direction(vector, rotate_clockwise(vector.direction(), angle));
		}
		
		Vector rotate_clockwise(Vector &&vector, const double angle) {
			return with_direction(std::move(vector), rotate_clockwise(vector.direction(), angle));
		}
		
		Vector rotate_counterclockwise(const Vector &vector, const double angle) {
			return rotate_clockwise(vector, -angle);
		}
		
		Vector rotate_counterclockwise(Vector &&vector, const double angle) {
			return rotate_clockwise(std::move(vector), -angle);
		}
		
		Vector with_direction(const Vector &vector, const Direction &direction) {
			return Vector(direction, vector.magnitude());
		}
		
		Vector with_direction(Vector &&vector, const Direction &direction) {
			vector.direction(direction);
			return vector;
		}
		
		Vector with_magnitude(const Vector &vector, const double magnitude) {
			return Vector(vector.direction(), magnitude);
		}
		
		Vector with_magnitude(Vector &&vector, const double magnitude) {
			vector.magnitude(magnitude);
			return vector;
		}
		
		Vector invert(const Vector &vector) {
			return with_direction(vector, invert(vector.direction()));
		}
		
		Vector invert(Vector &&vector) {
			return with_direction(std::move(vector), invert(vector.direction()));
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
		
		Vector operator -(Vector &&vector) {
			return invert(std::move(vector));
		}
		
		Vector operator -(const Vector &lhs, const Vector &rhs) {
			return lhs + -rhs;
		}
		
		Vector operator -(const Vector &lhs, Vector &&rhs) {
			return lhs + -std::move(rhs);
		}
		
		Vector operator *(const Vector &lhs, const double rhs) {
			return with_magnitude(lhs, lhs.magnitude() * rhs);
		}
		
		Vector operator *(Vector &&lhs, const double rhs) {
			return with_magnitude(std::move(lhs), lhs.magnitude() * rhs);
		}

		double x(const Vector &vector) {
			return vector.magnitude() * sin(vector.direction().clockwise_angle_with_above());
		}
		
		double y(const Vector &vector) {
			return vector.magnitude() * cos(vector.direction().clockwise_angle_with_above());
		}
	}
}
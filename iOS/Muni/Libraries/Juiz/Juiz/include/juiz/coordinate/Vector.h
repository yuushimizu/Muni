#ifndef __Juiz__coordinate__Vector__
#define __Juiz__coordinate__Vector__

#include "juiz/coordinate/Direction.h"
#include "juiz/coordinate/Point.h"
#include <utility>

namespace juiz {
	namespace coordinate {
		class Vector {
		private:
			Direction direction_;
			double magnitude_;
		public:
			Vector(const Direction &direction, const double magnitude);
			Vector();
			Direction direction() const;
			void direction(const Direction &direction);
			double magnitude() const;
			void magnitude(const double magnitude);
		};
		bool operator ==(const Vector &lhs, const Vector &rhs);
		bool operator !=(const Vector &lhs, const Vector &rhs);
		Vector with_direction(const Vector &vector, const Direction &direction);
		Vector with_direction(Vector &&vector, const Direction &direction);
		Vector with_magnitude(const Vector &vector, const double magnitude);
		Vector with_magnitude(Vector &&vector, const double magnitude);
		Vector rotate_clockwise(const Vector &vector, const double angle);
		Vector rotate_clockwise(Vector &&vector, const double angle);
		Vector rotate_counterclockwise(const Vector &vector, const double angle);
		Vector rotate_counterclockwise(Vector &&vector, const double angle);
		Vector invert(const Vector &vector);
		Vector invert(Vector &&vector);
		Vector operator +(const Vector &vector);
		Vector operator +(const Vector &lhs, const Vector &rhs);
		Vector operator -(const Vector &vector);
		Vector operator -(Vector &&vector);
		Vector operator -(const Vector &lhs, const Vector &rhs);
		Vector operator -(const Vector &lhs, Vector &&rhs);
		Vector operator *(const Vector &lhs, const double rhs);
		Vector operator *(Vector &&lhs, const double rhs);
		double x(const Vector &vector);
		double y(const Vector &vector);
	}
}

#endif

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
			Vector direction(const Direction &direction) const;
			double magnitude() const;
			Vector magnitude(const double magnitude) const;
		};
		bool operator ==(const Vector &lhs, const Vector &rhs);
		bool operator !=(const Vector &lhs, const Vector &rhs);
		Vector operator +(const Vector &vector);
		Vector operator +(const Vector &lhs, const Vector &rhs);
		Vector operator -(const Vector &vector);
		Vector operator -(const Vector &lhs, const Vector &rhs);
		Vector operator *(const Vector &lhs, const double rhs);
		Vector rotate_clockwise(const Vector &vector, const double angle);
		Vector rotate_counterclockwise(const Vector &vector, const double angle);
		Vector invert(const Vector &vector);
		double x(const Vector &vector);
		double y(const Vector &vector);
	}
}

#endif

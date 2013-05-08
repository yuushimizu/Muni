#ifndef __Juiz__coordinate__Vector__
#define __Juiz__coordinate__Vector__

#include "juiz/coordinate/Direction.h"

namespace juiz {
	namespace coordinate {
		class Vector {
		private:
			Direction direction_;
			double magnitude_;
		public:
			Vector(const Direction direction, const double magnitude);
			Vector();
			const Direction direction() const;
			const double magnitude() const;
		};
		const bool operator ==(const Vector &lhs, const Vector &rhs);
		const bool operator !=(const Vector &lhs, const Vector &rhs);
		const Vector operator +(const Vector &vector);
		const Vector operator +(const Vector &lhs, const Vector &rhs);
		const Vector operator -(const Vector &vector);
		const Vector operator -(const Vector &lhs, const Vector &rhs);
		const Vector operator *(const Vector &lhs, const double &rhs);
		const Vector vector(const double x, const double y);
		const double x(const Vector &vector);
		const double y(const Vector &vector);
	}
}

#endif

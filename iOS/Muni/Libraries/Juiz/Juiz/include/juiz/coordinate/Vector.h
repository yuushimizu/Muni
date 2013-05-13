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
		Vector operator +(const Vector &vector);
		Vector operator +(const Vector &lhs, const Vector &rhs);
		Vector operator -(const Vector &vector);
		Vector operator -(Vector &&vector);
		template <typename LHS, typename RHS>
		Vector operator -(LHS &&lhs, RHS &&rhs) {
			return std::forward<LHS>(lhs) + -std::forward<RHS>(rhs);
		}
		Vector operator *(const Vector &lhs, const double rhs);
		Vector operator *(Vector &&lhs, const double rhs);
		double x(const Vector &vector);
		double y(const Vector &vector);
	}
}

#endif

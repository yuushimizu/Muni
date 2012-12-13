#ifndef __Juiz__coordinate__Vector__
#define __Juiz__coordinate__Vector__

namespace juiz {
	namespace coordinate {
		class PointInterval;
		class Vector {
		private:
			double direction_;
			double magnitude_;
		public:
			Vector();
			Vector(const double direction, const double magnitude);
			const double direction() const;
			const double direction(const double direction);
			const double magnitude() const;
			const double magnitude(const double magnitude);
		};
		const bool operator ==(const Vector &lhs, const Vector &rhs);
		const bool operator !=(const Vector &lhs, const Vector &rhs);
	}
}

#endif /* defined(__Juiz__coordinate__Vector__) */

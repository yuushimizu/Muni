#include "CellFamily.h"
#include <math.h>
#include <algorithm>

namespace muni {
	CellFamily::CellFamily() : value_(0) {
	}
	
	CellFamily::CellFamily(const double value) : value_(value) {
	}
	
    const double CellFamily::value() const {
	    return this->value_;
    }

    const bool hostility(const CellFamily &cellFamily1, const CellFamily &cellFamily2) {
		return std::min(fabs(cellFamily1.value() - cellFamily2.value()), std::min(fabs(cellFamily1.value() - (cellFamily2.value() - 1.0)), fabs(cellFamily1.value() - (cellFamily2.value() + 1.0)))) > 0.15;
    }
}
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

    const bool hostility(const CellFamily &cell_family_1, const CellFamily &cell_family_2) {
		return std::min(fabs(cell_family_1.value() - cell_family_2.value()), std::min(fabs(cell_family_1.value() - (cell_family_2.value() - 1.0)), fabs(cell_family_1.value() - (cell_family_2.value() + 1.0)))) > 0.15;
    }
}
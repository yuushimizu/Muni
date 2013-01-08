#include "Field.h"

namespace muni {
	Field::Field(const juiz::Size &size) : size_(size) {
	}
	
	const juiz::Size Field::size() const {
		return this->size_;
	}
}

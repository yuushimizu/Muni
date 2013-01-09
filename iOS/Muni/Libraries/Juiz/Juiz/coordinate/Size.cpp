#include "juiz/coordinate/Size.h"

namespace juiz {
	namespace coordinate {
		Size::Size(const double width, const double height) : width_(width), height_(height) {
		}
		
		Size::Size() : Size(0, 0) {
		}
		
		const double Size::width() const {
			return this->width_;
		}
		
		const double Size::width(const double width) {
			return this->width_ = width;
		}
		
		const double Size::height() const {
			return this->height_;
		}
		
		const double Size::height(const double height) {
			return this->height_ = height;
		}
		
		const bool operator==(const Size &lhs, const Size &rhs) {
			return lhs.width() == rhs.width() && lhs.height() == rhs.height();
		}
		
		const bool operator!=(const Size &lhs, const Size &rhs) {
			return !(lhs == rhs);
		}
	}
}
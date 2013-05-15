#include "juiz/coordinate/Size.h"
#include <math.h>

namespace juiz {
	namespace coordinate {
		Size::Size(const double width, const double height) : width_(width), height_(height) {
		}
		
		Size::Size() : Size(0, 0) {
		}
		
		double Size::width() const {
			return this->width_;
		}
		
		Size Size::width(const double width) const {
			Size newSize(*this);
			newSize.width_ = width;
			return newSize;
		}
		
		double Size::height() const {
			return this->height_;
		}
		
		Size Size::height(const double height) const {
			Size newSize(*this);
			newSize.height_ = height;
			return newSize;
		}
		
		bool operator==(const Size &lhs, const Size &rhs) {
			return lhs.width() == rhs.width() && lhs.height() == rhs.height();
		}
		
		bool operator!=(const Size &lhs, const Size &rhs) {
			return !(lhs == rhs);
		}
		
		double diagonal(const Size &size) {
			return sqrt(pow(size.width(), 2) + pow(size.height(), 2));
		}
	}
}
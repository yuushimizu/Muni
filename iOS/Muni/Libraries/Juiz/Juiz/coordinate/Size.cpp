#include "juiz/coordinate/Size.h"

namespace juiz {
	namespace coordinate {
		Size::Size(const double width, const double height) : width_(width), height_(height) {
		}
		
		Size::Size() : Size(0, 0) {
		}
		
		double Size::width() const {
			return this->width_;
		}
		
		void Size::width(const double width) {
			this->width_ = width;
		}
		
		double Size::height() const {
			return this->height_;
		}
		
		void Size::height(const double height) {
			this->height_ = height;
		}
		
		bool operator==(const Size &lhs, const Size &rhs) {
			return lhs.width() == rhs.width() && lhs.height() == rhs.height();
		}
		
		bool operator!=(const Size &lhs, const Size &rhs) {
			return !(lhs == rhs);
		}
	}
}
#ifndef __Juiz__coordinate__Size__
#define __Juiz__coordinate__Size__

namespace juiz {
	namespace coordinate {
		class Size {
		private:
			double width_;
			double height_;
		public:
			Size(const double width, const double height);
			Size();
			double width() const;
			void width(const double width);
			double height() const;
			void height(const double height);
		};
		bool operator==(const Size &lhs, const Size &rhs);
		bool operator!=(const Size &lhs, const Size &rhs);
		Size with_width(const Size &size, const double width);
		Size with_width(Size &&size, const double width);
		Size with_height(const Size &size, const double height);
		Size with_height(Size &&size, const double height);
	}
}

#endif

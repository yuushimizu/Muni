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
			Size width(const double width) const;
			double height() const;
			Size height(const double height) const;
		};
		bool operator==(const Size &lhs, const Size &rhs);
		bool operator!=(const Size &lhs, const Size &rhs);
		double diagonal(const Size &size);
	}
}

#endif

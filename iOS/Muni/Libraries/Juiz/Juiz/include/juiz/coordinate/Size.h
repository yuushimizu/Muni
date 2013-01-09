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
			const double width() const;
			const double width(const double width);
			const double height() const;
			const double height(const double height);
		};
		const bool operator==(const Size &lhs, const Size &rhs);
		const bool operator!=(const Size &lhs, const Size &rhs);
	}
}

#endif /* defined(__Juiz__coordinate__Size__) */

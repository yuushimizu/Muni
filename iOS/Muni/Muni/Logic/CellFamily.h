#ifndef __Muni__CellFamily__
#define __Muni__CellFamily__

namespace muni {
	class CellFamily {
	private:
		double value_;
	public:
		CellFamily();
		explicit CellFamily(const double value);
		const double value() const;
	};
	const bool hostility(const CellFamily &cellFamily1, const CellFamily &cellFamily2);
}

#endif /* defined(__Muni__CellFamily__) */

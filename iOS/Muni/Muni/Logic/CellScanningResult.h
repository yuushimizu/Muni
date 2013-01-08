#ifndef __Muni__CellScanningResult__
#define __Muni__CellScanningResult__

@protocol MNCell;

namespace muni {
	class CellScanningResult {
	private:
		id<MNCell> cell_;
		double distance_;
	public:
		CellScanningResult();
		CellScanningResult(id<MNCell> cell, const double distance);
		id<MNCell> cell() const;
		const double distance() const;
	};
}

#endif /* defined(__Muni__CellScanningResult__) */
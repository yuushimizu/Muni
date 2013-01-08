#import "CellScanningResult.h"

namespace muni {
	CellScanningResult::CellScanningResult() : cell_(nil), distance_(0) {
	}
	
	CellScanningResult::CellScanningResult(id<MNCell> cell, const double distance) : cell_(cell), distance_(distance) {
	}
	
	id<MNCell> CellScanningResult::cell() const {
		return this->cell_;
	}
	
	const double CellScanningResult::distance() const {
		return this->distance_;
	}
}

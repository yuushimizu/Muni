#import "CellActionMultiply.h"
#import "MNUtility.h"

namespace muni {
	CellActionMultiply::CellActionMultiply(const int max_count, const double incidence) : rest_count_(max_count), incidence_(incidence) {
	}

	void CellActionMultiply::send_frame(id<MNCell> cell, Environment &environment) {
		if (rest_count_ <= 0) return;
		if (MNRandomDouble(0, 1) >= incidence_) return;
		if ([cell multiplyWithEnvironment:&environment]) {
			rest_count_--;
		}
	}
}

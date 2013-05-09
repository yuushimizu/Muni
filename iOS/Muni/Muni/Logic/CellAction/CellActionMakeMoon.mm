#import "CellActionMakeMoon.h"
#import "MNUtility.h"

namespace muni {
	CellActionMakeMoon::CellActionMakeMoon(const double distance, const double radian_increase, const int max_count, const double incidence) : distance_(distance), radian_increase_(radian_increase), rest_count_(max_count), incidence_(incidence) {
	}
	
	void CellActionMakeMoon::send_frame(id<MNCell> cell, Environment &environment) {
		if (rest_count_ <= 0 || MNRandomDouble(0, 1) >= incidence_) return;
		if ([cell makeMoonWithDistance:distance_ withRadianIncrease:radian_increase_ withEnvironment:&environment]) {
			rest_count_--;
		}
	}
}

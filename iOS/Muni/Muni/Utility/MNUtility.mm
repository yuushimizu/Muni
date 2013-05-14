#import "MNUtility.h"

const double MNRandomDouble(double min, double limit) {
	return ((double) rand() / (RAND_MAX + 1.0)) * (limit - min) + min;
}

const int MNRandomInt(int min, int limit) {
	return ((double) rand() / (RAND_MAX + 1.0)) * (limit - min) + min;
}

const BOOL MNRandomBool(void) {
	return MNRandomInt(0, 2) == 0;
}

const juiz::Point MNRandomPointInSize(const juiz::Size &size) {
	return juiz::Point(((double) rand() / (RAND_MAX + 1.0)) * size.width(), ((double) rand() / (RAND_MAX + 1.0)) * size.height());
}

const double MNRandomRadian(void) {
	return MNRandomDouble(0, M_PI * 2);
}

const juiz::Direction MNRandomDirection(void) {
	return juiz::Direction(MNRandomRadian());
}

#import "TestUtility.h"

const bool doubles_in_allowable_range(const double double1, const double double2) {
	return fabs(double1) - fabs(double2) < 0.00001;
}

const bool points_are_same(const juiz::Point &point1, const juiz::Point &point2) {
	return doubles_in_allowable_range(point1.x(), point2.x()) && doubles_in_allowable_range(point1.y(), point2.y());
}

const bool point_intervals_are_same(const juiz::PointInterval &point_interval1, const juiz::PointInterval &point_interval2) {
	return doubles_in_allowable_range(point_interval1.x(), point_interval2.x()) && doubles_in_allowable_range(point_interval1.y(), point_interval2.y());
}

const bool sizes_are_same(const juiz::Size &size1, const juiz::Size &size2) {
	return doubles_in_allowable_range(size1.width(), size2.width()) && doubles_in_allowable_range(size1.height(), size2.height());
}

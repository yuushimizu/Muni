#import "TestUtility.h"

const bool roughly_equal(const double double1, const double double2) {
	return fabs(double1 - double2) < 0.00001;
}

const bool roughly_equal(const juiz::Point &point1, const juiz::Point &point2) {
	return roughly_equal(point1.x(), point2.x()) && roughly_equal(point1.y(), point2.y());
}

const bool roughly_equal(const juiz::Direction &direction1, const juiz::Direction &direction2) {
	return roughly_equal(direction1.clockwise_angle_with_above(), direction2.clockwise_angle_with_above()) || roughly_equal(direction1.clockwise_angle_with_above() + M_PI * 2, direction2.clockwise_angle_with_above()) || roughly_equal(direction1.clockwise_angle_with_above(), direction2.clockwise_angle_with_above() + M_PI * 2);
}

const bool roughly_equal(const juiz::Vector &vector1, const juiz::Vector &vector2) {
	return roughly_equal(vector1.direction(), vector2.direction()) && roughly_equal(vector1.magnitude(), vector2.magnitude());
}

const bool roughly_equal(const juiz::Size &size1, const juiz::Size &size2) {
	return roughly_equal(size1.width(), size2.width()) && roughly_equal(size1.height(), size2.height());
}

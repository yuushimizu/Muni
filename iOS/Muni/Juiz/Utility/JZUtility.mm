#import "JZUtility.h"

const juiz::Point JZMovedPointToDestination(const juiz::Point &start, const juiz::Point &destination, double moveDistance) {
	const juiz::Vector vector = juiz::vector(start, destination);
	if (vector.magnitude() <= moveDistance) return destination;
	return juiz::add_vector(start, juiz::with_magnitude(vector, moveDistance));
}

const juiz::Point JZRotatedPoint(const juiz::Point &source, const juiz::Point &origin, double radian) {
	const juiz::Vector vector = juiz::vector(origin, source);
	return juiz::add_vector(origin, juiz::with_direction(vector, juiz::rotate_clockwise(vector.direction(), radian)));
}

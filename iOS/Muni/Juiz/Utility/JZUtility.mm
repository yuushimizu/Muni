#import "JZUtility.h"

const juiz::Point JZMovedPointToDestination(const juiz::Point &start, const juiz::Point &destination, double moveDistance) {
	const juiz::Vector vector = juiz::vector(start, destination);
	if (vector.magnitude() <= moveDistance) return destination;
	return juiz::add_vector(start, vector.magnitude(moveDistance));
}

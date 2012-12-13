#import "JZUtility.h"

const double JZDistanceOfPoints(const juiz::Point &point1, const juiz::Point &point2) {
	double x = point1.x() - point2.x();
	double y = point1.y() - point2.y();
	return sqrt(x * x + y * y);
}

const double JZRadianFromPoints(const juiz::Point &start, const juiz::Point &destination) {
	return atan2(destination.x() - start.x(), destination.y() - start.y());
}

const juiz::Point JZManhattanDiffFromRadianAndDistance(double radian, double distance) {
	return juiz::Point(sin(radian) * distance, cos(radian) * distance);
}

const juiz::Point JZMovedPoint(const juiz::Point &start, double radian, double distance) {
	juiz::Point manhattanDiff = JZManhattanDiffFromRadianAndDistance(radian, distance);
	return juiz::Point(start.x() + manhattanDiff.x(), start.y() + manhattanDiff.y());
}

const juiz::Point JZMovedPointToDestination(const juiz::Point &start, const juiz::Point &destination, double moveDistance) {
	double distance = JZDistanceOfPoints(start, destination);
	if (distance <= moveDistance) return destination;
	return JZMovedPoint(start, JZRadianFromPoints(start, destination), moveDistance);
}

const double JZDiagonalFromSize(const juiz::Size &size) {
	return sqrt(size.width() * size.width() + size.height() * size.height());
}

const double JZInvertRadian(double radian) {
	return radian < M_PI ? radian + M_PI : radian - M_PI;
}

const juiz::Point JZRotatedPoint(const juiz::Point &source, const juiz::Point &origin, double radian) {
	return JZMovedPoint(origin, JZRadianFromPoints(origin, source) + radian, JZDistanceOfPoints(origin, source));
}

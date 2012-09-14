#import "JZUtility.h"

double JZDistanceOfPoints(CGPoint point1, CGPoint point2) {
	double x = point1.x - point2.x;
	double y = point1.y - point2.y;
	return sqrt(x * x + y * y);
}

double JZRadianFromPoints(CGPoint start, CGPoint destination) {
	return atan2(destination.x - start.x, destination.y - start.y);
}

CGPoint JZManhattanDiffFromRadianAndDistance(double radian, double distance) {
	return CGPointMake(sin(radian) * distance, cos(radian) * distance);
}

CGPoint JZMovedPoint(CGPoint start, double radian, double distance) {
	CGPoint manhattanDiff = JZManhattanDiffFromRadianAndDistance(radian, distance);
	return CGPointMake(start.x + manhattanDiff.x, start.y + manhattanDiff.y);
}

CGPoint JZMovedPointToDestination(CGPoint start, CGPoint destination, double moveDistance) {
	double distance = JZDistanceOfPoints(start, destination);
	if (distance <= moveDistance) return destination;
	return JZMovedPoint(start, JZRadianFromPoints(start, destination), moveDistance);
}

double JZDiagonalFromSize(CGSize size) {
	return sqrt(size.width * size.width + size.height * size.height);
}

double JZInvertRadian(double radian) {
	return radian < M_PI ? radian + M_PI : radian - M_PI;
}

CGPoint JZRotatedPoint(CGPoint source, CGPoint origin, double radian) {
	return JZMovedPoint(origin, JZRadianFromPoints(origin, source) + radian, JZDistanceOfPoints(origin, source));
}

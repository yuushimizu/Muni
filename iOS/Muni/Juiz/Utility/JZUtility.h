#import "juiz.h"

const double JZRadianFromPoints(const juiz::Point &start, const juiz::Point &destination);
const juiz::Point JZManhattanDiffFromRadianAndDistance(double radian, double distance);
const double JZRadianFromManhattanDiff(const juiz::Point &manhattanDiff);
const double JZDistanceFromManhattanDiff(const juiz::Point &manhattanDiff);
const juiz::Point JZMovedPoint(const juiz::Point &start, double radian, double distance);
const juiz::Point JZMovedPointToDestination(const juiz::Point &start, const juiz::Point &destination, double distance);
const double JZDiagonalFromSize(const juiz::Size &size);
const double JZInvertRadian(double radian);
const juiz::Point JZRotatedPoint(const juiz::Point &source, const juiz::Point &origin, double radian);

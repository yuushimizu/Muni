//
//  MNUtility.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNUtility.h"

double MNRandomDouble(double min, double limit) {
	return ((double) rand() / (RAND_MAX + 1.0)) * (limit - min) + min;
}

int MNRandomInt(int min, int limit) {
	return ((double) rand() / (RAND_MAX + 1.0)) * (limit - min) + min;
}

BOOL MNRandomBool(void) {
	return MNRandomInt(0, 2) == 0;
}

CGPoint MNRandomPointInSize(CGSize size) {
	return CGPointMake(((double) rand() / (RAND_MAX + 1.0)) * size.width, ((double) rand() / (RAND_MAX + 1.0)) * size.height);
}

UIColor *MNRandomColor(void) {
	return [UIColor colorWithRed:MNRandomDouble(0, 1.0) green:MNRandomDouble(0, 1.0) blue:MNRandomDouble(0, 1.0) alpha:1.0];
}

double MNRandomRadian(void) {
	return MNRandomDouble(0, M_PI * 2);
}

double MNDistanceOfPoints(CGPoint point1, CGPoint point2) {
	double x = point1.x - point2.x;
	double y = point1
	.y - point2.y;
	return sqrt(x * x + y * y);
}

double MNRadianFromPoints(CGPoint start, CGPoint destination) {
	return atan2(destination.x - start.x, destination.y - start.y);
}

CGPoint MNManhattanDiffFromRadianAndDistance(double radian, double distance) {
	return CGPointMake(sin(radian) * distance, cos(radian) * distance);
}

CGPoint MNMovedPoint(CGPoint start, double radian, double distance) {
	CGPoint manhattanDiff = MNManhattanDiffFromRadianAndDistance(radian, distance);
	return CGPointMake(start.x + manhattanDiff.x, start.y + manhattanDiff.y);
}

CGPoint MNMovedPointToDestination(CGPoint start, CGPoint destination, double moveDistance) {
	double distance = MNDistanceOfPoints(start, destination);
	if (distance <= moveDistance) return destination;
	return MNMovedPoint(start, MNRadianFromPoints(start, destination), moveDistance);
}

double MNDiagonalFromSize(CGSize size) {
	return sqrt(size.width * size.width + size.height * size.height);
}

double MNInvertRadian(double radian) {
	return radian < M_PI ? radian + M_PI : radian - M_PI;
}
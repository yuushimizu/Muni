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

CGPoint MNRandomPointInSize(CGSize size) {
	return CGPointMake(((double) rand() / (RAND_MAX + 1.0)) * size.width, ((double) rand() / (RAND_MAX + 1.0)) * size.height);
}

UIColor *MNRandomColor(void) {
	return [UIColor colorWithRed:MNRandomDouble(0, 1.0) green:MNRandomDouble(0, 1.0) blue:MNRandomDouble(0, 1.0) alpha:1.0];
}

double MNRandomRadian(void) {
	return MNRandomDouble(0, M_PI * 2);
}

CGPoint MNMovedPoint(CGPoint start, double radian, double distance) {
	id<MNPointInterval> interval = [[MNPointIntervalByRadianAndDistance alloc] initWithRadian:radian withDistance:distance];
	return CGPointMake(start.x + interval.x, start.y + interval.y);
}

CGPoint MNMovedPointToDestination(CGPoint start, CGPoint destination, double moveDistance) {
	id<MNPointInterval> interval = [[MNPointIntervalByPoints alloc] initWithSource:start withDestination:destination];
	if (interval.distance <= moveDistance) return destination;
	return MNMovedPoint(start, interval.radian, moveDistance);
}

double MNDiagonalFromSize(CGSize size) {
	return [[MNPointIntervalByPoints alloc] initWithSource:CGPointMake(0, 0) withDestination:CGPointMake(size.width, size.height)].distance;
}

double MNInvertRadian(double radian) {
	return radian < M_PI ? radian + M_PI : radian - M_PI;
}
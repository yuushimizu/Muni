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

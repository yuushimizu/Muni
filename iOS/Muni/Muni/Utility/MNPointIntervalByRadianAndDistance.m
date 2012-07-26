//
//  MNPointIntervalByRadianAndDistance.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNPointIntervalByRadianAndDistance.h"

@implementation MNPointIntervalByRadianAndDistance

- (id)initWithRadian:(double)radian withDistance:(double)distance {
	if (self = [super init]) {
		_radian = radian;
		_distance = distance;
	}
	return self;
}

- (double)x {
	return sin(_radian) * _distance;
}

- (double)y {
	return cos(_radian) * _distance;
}

- (double)radian {
	return _radian;
}

- (double)distance {
	return _distance;
}

@end

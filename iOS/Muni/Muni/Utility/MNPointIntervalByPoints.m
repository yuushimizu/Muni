//
//  MNPointIntervalByPoints.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNPointIntervalByPoints.h"

@implementation MNPointIntervalByPoints

- (id)initWithSource:(CGPoint)source withDestination:(CGPoint)destination {
	if (self = [super init]) {
		_source = source;
		_destination = destination;
	}
	return self;
}

- (double)x {
	return _destination.x - _source.x;
}

- (double)y {
	return _destination.y - _source.y;
}

- (double)distance {
	double x = self.x;
	double y = self.y;
	return sqrt(x * x + y * y);
}

- (double)radian {
	return atan2(self.x, self.y);
}

@end

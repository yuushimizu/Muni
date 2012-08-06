//
//  MNCellActionMakeMoon.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellActionMakeMoon.h"

@implementation MNCellActionMakeMoon

- (id)initWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withMaxCount:(int)maxCount withIncidence:(double)incidence {
	if (self = [super init]) {
		_distance = distance;
		_radianIncrease = radianIncrease;
		_restCount = maxCount;
		_incidence = incidence;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (_restCount <= 0 || MNRandomDouble(0, 1) >= _incidence) return;
	[cell makeMoonWithDistance:_distance withRadianIncrease:_radianIncrease withEnvironment:environment];
}

@end

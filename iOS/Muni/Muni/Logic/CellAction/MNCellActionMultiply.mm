//
//  MNCellActionMultiply.m
//  Muni
//
//  Created by Yuu Shimizu on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellActionMultiply.h"

@implementation MNCellActionMultiply

- (id)initWithMaxCount:(int)maxCount withIncidence:(double)incidence {
	if (self = [super init]) {
		_restCount = maxCount;
		_incidence = incidence;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (_restCount <= 0) return;
	if (MNRandomDouble(0, 1) >= _incidence) return;
	if ([cell multiplyWithEnvironment:environment]) {
		_restCount -= 1;
	}
}

@end

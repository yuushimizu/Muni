//
//  MNCellActionMakeTracer.m
//  Muni
//
//  Created by Yuu Shimizu on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellActionMakeTracer.h"

@implementation MNCellActionMakeTracer

- (id)initWithIntervalFrames:(int)intervalFrames withIncidence:(double)incidence {
	if (self = [super init]) {
		_intervalFrames = intervalFrames;
		_incidence = incidence;
		_generated = NO;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (_generated || MNRandomDouble(0, 1) >= _incidence) return;
	[cell makeTracerWithIntervalFrames:_intervalFrames withEnvironment:environment];
	_generated = YES;
}

@end

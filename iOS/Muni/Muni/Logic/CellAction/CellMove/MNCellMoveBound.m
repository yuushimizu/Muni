//
//  MNCellMoveBound.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveBound.h"

@implementation MNCellMoveBound

- (id)init {
	if (self = [super init]) {
		_radian = MNRandomRadian();
		_moved = NO;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell WithEnvironment:(id<MNEnvironment>)environment {
	if (_moved) {
		[cell moveFor:cell.movingRadian];
	} else {
		_moved = YES;
		[cell moveFor:_radian];
	}
}

@end

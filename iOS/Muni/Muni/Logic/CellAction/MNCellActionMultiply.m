//
//  MNCellActionMultiply.m
//  Muni
//
//  Created by Yuu Shimizu on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellActionMultiply.h"

@implementation MNCellActionMultiply

- (id)init {
	if (self = [super init]) {
		_restCount = 2;
		_incidence = 0.002;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell WithEnvironment:(id<MNEnvironment>)environment {
	if (_restCount <= 0) return;
	if (MNRandomDouble(0, 1) >= _incidence) return;
	[cell multiplyWithEnvironment:environment];
}

@end

//
//  MNCellMoveMoon.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveMoon.h"

@implementation MNCellMoveMoon

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super initWithCell:cell withCondition:condition withMoveWithoutTarget:moveWihtoutTarget withEnvironment:environment]) {
		_distance = distance;
		_radianIncrease = radianIncrease;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	[cell moveTowards:MNMovedPoint(target.center, MNRadianFromPoints(target.center, cell.center) + _radianIncrease, _distance + cell.radius + target.radius)];
}

@end

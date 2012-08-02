//
//  MNCellMoveTailNearestTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveTailNearestTarget.h"

@implementation MNCellMoveTailNearestTarget

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withEnvironment:(id<MNEnvironment>)environment {
if (self = [super init]) {
	_targetCondition = condition;
	_moveWithoutTarget = moveWihtoutTarget;
}
return self;
}

- (id<MNCell>)searchNearestTargetWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	NSArray *scanningResults = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
		return _targetCondition(cell, candidate);
	} withEnvironment:environment];
	return scanningResults.count > 0 ? ((MNCellScanningResult *) [scanningResults objectAtIndex:0]).cell : nil;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	id<MNCell> target = [self searchNearestTargetWithCell:cell withEnvironment:environment];
	if (target) {
		[cell moveTowards:target.center];
	} else {
		[_moveWithoutTarget sendFrameWithCell:cell withEnvironment:environment];
	}
}

@end

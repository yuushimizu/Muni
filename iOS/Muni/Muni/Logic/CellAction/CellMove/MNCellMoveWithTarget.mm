//
//  MNCellMoveWithTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveWithTarget.h"
#import "JZUtility.h"

@implementation MNCellMoveWithTarget

- (void)resetTargetWithCell:(id<MNCell>)cell Environment:(id<MNEnvironment>)environment {
	NSArray *scanningResults = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
		return _targetCondition(cell, candidate);
	} withEnvironment:environment];
	_target = scanningResults.count > 0 ? ((MNCellScanningResult *) [scanningResults objectAtIndex:0]).cell : nil;
	if (_target) [self foundNewTarget:_target];
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget {
	if (self = [super init]) {
		_targetCondition = condition;
		_moveWithoutTarget = moveWihtoutTarget;
	}
	return self;
}

- (void)foundNewTarget:(id<MNCell>)target {
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (!_target || !_target.living) {
		[self resetTargetWithCell:cell Environment:environment];
	} else if (JZDistanceOfPoints(cell.center, _target.center) - cell.radius - _target.radius > cell.sight) {
		[self resetTargetWithCell:cell Environment:environment];
	}
	if (_target) {
		[self sendFrameWithCell:cell withTarget:_target withEnvironment:environment];
	} else {
		[_moveWithoutTarget sendFrameWithCell:cell withEnvironment:environment];
	}
}

@end

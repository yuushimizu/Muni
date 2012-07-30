//
//  MNCellMoveTailTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveTailTarget.h"

@implementation MNCellMoveTailTarget

- (void)resetTargetWithCell:(id<MNCell>)cell Environment:(id<MNEnvironment>)environment {
	NSArray *scanningResults = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
		return _targetCondition(cell, candidate);
	} withEnvironment:environment];
	if (scanningResults.count > 0) {
		MNCellScanningResult *scanningResult = [scanningResults objectAtIndex:0];
		_target = scanningResult.cell;
	} else {
		_target = nil;
	}
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellMove *)moveWihtoutTarget withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_targetCondition = condition;
		_moveWithoutTarget = moveWihtoutTarget;
		[self resetTargetWithCell:cell Environment:environment];
	}
	return self;
}

- (CGPoint)pointMovedOfCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (!_target || !_target.living) [self resetTargetWithCell:cell Environment:environment];
	if (_target) {
		return MNMovedPointToDestination(cell.center, _target.center, cell.speed);
	} else {
		return [_moveWithoutTarget pointMovedOfCell:cell withEnvironment:environment];
	}
}

@end

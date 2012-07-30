//
//  MNCellMoveTailTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveTailTarget.h"

@implementation MNCellMoveTailTarget

- (void)resetTarget {
	NSArray *scanningResults = [self.cell scanCells:^(id<MNCell> candidate) {
		return _targetCondition(self.cell, candidate);
	}];
	if (scanningResults.count > 0) {
		MNCellScanningResult *scanningResult = [scanningResults objectAtIndex:0];
		_target = scanningResult.cell;
	} else {
		_target = nil;
	}
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell> me, id<MNCell> other))condition withMoveWithoutTarget:(MNCellMove *)moveWihtoutTarget {
	if (self = [super initWithCell:cell]) {
		_targetCondition = condition;
		_moveWithoutTarget = moveWihtoutTarget;
		[self resetTarget];
	}
	return self;
}

- (CGPoint)pointMoved {
	if (!_target || !_target.living) [self resetTarget];
	if (_target) {
		return MNMovedPointToDestination(self.cell.center, _target.center, self.cell.speed);
	} else {
		return [_moveWithoutTarget pointMoved];
	}
}

@end

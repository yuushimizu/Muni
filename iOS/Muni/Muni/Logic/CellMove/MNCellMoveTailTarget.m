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
	NSArray *scanningResults = [self.environment scanCellsBy:self.cell withCondition:_targetCondition];
	if (scanningResults.count > 0) {
		MNCellScanningResult *scanningResult = [scanningResults objectAtIndex:0];
		_target = scanningResult.cell;
	} else {
		_target = nil;
	}
}

- (id)initWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super initWithCell:cell withEnvironment:environment]) {
		_targetCondition = [[MNCellTargetConditionEnemy alloc] initWithCell:cell];
		[self resetTarget];
	}
	return self;
}

- (CGPoint)pointMoved {
	if (!_target || !_target.living) [self resetTarget];
	if (!_target) {
		return self.cell.center;
	} else {
		return MNMovedPointToDestination(self.cell.center, _target.center, self.cell.speed);
	}
}

@end

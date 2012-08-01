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

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMinDistance:(double)minDistance withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_targetCondition = condition;
		_moveWithoutTarget = moveWihtoutTarget;
		_minDistance = minDistance;
		[self resetTargetWithCell:cell Environment:environment];
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell WithEnvironment:(id<MNEnvironment>)environment {
	double distance = MNDistanceOfPoints(cell.center, _target.center) - cell.radius - _target.radius;
	if (!_target || !_target.living || distance > cell.sight) [self resetTargetWithCell:cell Environment:environment];
	if (_target) {
		if (distance > _minDistance) {
			[cell moveTowards:_target.center];
		} else {
			[cell moveFor:MNInvertRadian(MNRadianFromPoints(cell.center, _target.center))];
		}
	} else {
		[_moveWithoutTarget sendFrameWithCell:cell WithEnvironment:environment];
	}
}

@end

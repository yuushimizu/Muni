//
//  MNCellMoveTraceTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveTraceTarget.h"

@implementation MNCellMoveTraceTarget

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withIntervalFrames:(int)intervalFrames {
	if (self = [super initWithCell:cell withCondition:condition withMoveWithoutTarget:moveWihtoutTarget]) {
		_intervalFrames = intervalFrames;
		_positionsOfTarget = [NSMutableArray arrayWithCapacity:intervalFrames + 1];
	}
	return self;
}

- (void)foundNewTarget:(id<MNCell>)target {
	NSValue *firstPosition = [NSValue valueWithCGPoint:target.center];
	[_positionsOfTarget removeAllObjects];
	for (int i = -1; i < _intervalFrames; ++i) [_positionsOfTarget addObject:firstPosition];
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	if (!CGPointEqualToPoint(target.center, [[_positionsOfTarget objectAtIndex:0] CGPointValue])) {
		CGPoint nextPoint = [[_positionsOfTarget objectAtIndex:0] CGPointValue];
		[_positionsOfTarget removeObjectAtIndex:_intervalFrames];
		[_positionsOfTarget insertObject:[NSValue valueWithCGPoint:target.center] atIndex:0];
		[cell rotateTowards:nextPoint];
		[cell moveTowards:nextPoint];
	}
}

@end

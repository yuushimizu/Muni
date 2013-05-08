#import "MNCellMoveTraceTarget.h"
#import "juiz.h"

@implementation MNCellMoveTraceTarget

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withIntervalFrames:(int)intervalFrames {
	if (self = [super initWithCell:cell withCondition:condition withMoveWithoutTarget:moveWihtoutTarget]) {
		_intervalFrames = intervalFrames;
		_positionsOfTarget = [NSMutableArray arrayWithCapacity:intervalFrames + 1];
	}
	return self;
}

- (void)foundNewTarget:(id<MNCell>)target {
	NSValue *firstPosition = [NSValue valueWithCGPoint:juiz::cgPoint(target.center)];
	[_positionsOfTarget removeAllObjects];
	for (int i = -1; i < _intervalFrames; ++i) [_positionsOfTarget addObject:firstPosition];
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment {
	const juiz::Point nextPosition = juiz::point([[_positionsOfTarget objectAtIndex:0] CGPointValue]);
	if (target.center != nextPosition) {
		[_positionsOfTarget removeObjectAtIndex:_intervalFrames];
		[_positionsOfTarget insertObject:[NSValue valueWithCGPoint:juiz::cgPoint(target.center)] atIndex:0];
		[cell rotateTowards:nextPosition];
		[cell moveTowards:nextPosition];
	}
}

@end

#import "MNCellMoveMoon.h"
#import "JZUtility.h"

@implementation MNCellMoveMoon

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withDistance:(double)distance withRadianIncrease:(double)radianIncrease {
	if (self = [super initWithCell:cell withCondition:condition withMoveWithoutTarget:moveWihtoutTarget]) {
		_distance = distance;
		_radianIncrease = radianIncrease;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	[cell rotateTowards:target.center];
	[cell moveTowards:JZMovedPoint(target.center, JZRadianFromPoints(target.center, cell.center) + _radianIncrease, _distance + cell.radius + target.radius)];
}

@end

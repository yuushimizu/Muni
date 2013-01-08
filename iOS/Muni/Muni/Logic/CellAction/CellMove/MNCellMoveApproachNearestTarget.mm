#import "MNCellMoveApproachNearestTarget.h"

@implementation MNCellMoveApproachNearestTarget

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment {
	[cell rotateTowards:target.center];
	[cell moveTowards:target.center];
}

@end

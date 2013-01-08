#import "MNCellMoveApproachTarget.h"

@implementation MNCellMoveApproachTarget

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment {
	[cell rotateTowards:_target.center];
	[cell moveTowards:_target.center];
}

@end

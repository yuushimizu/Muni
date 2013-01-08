#import "MNCellMoveImmovable.h"

@implementation MNCellMoveImmovable

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	[cell stop];
}

@end

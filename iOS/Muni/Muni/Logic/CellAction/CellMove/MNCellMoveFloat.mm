#import "MNCellMoveFloat.h"

@implementation MNCellMoveFloat

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	[cell moveFor:MNRandomRadian()];
}

@end

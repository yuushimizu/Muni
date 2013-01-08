#import "MNCellMoveWithNearestTarget.h"

@implementation MNCellMoveWithNearestTarget

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget {
	if (self = [super init]) {
		_targetCondition = condition;
		_moveWithoutTarget = moveWihtoutTarget;
	}
	return self;
}

- (id<MNCell>)searchNearestTargetWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	std::vector<MNCellScanningResult *> scanningResults = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
		return _targetCondition(cell, candidate);
	} withEnvironment:environment];
	return scanningResults.size() > 0 ? scanningResults[0].cell : nil;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment {
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	id<MNCell> target = [self searchNearestTargetWithCell:cell withEnvironment:environment];
	if (target) {
		[self sendFrameWithCell:cell withTarget:target withEnvironment:environment];
	} else {
		[_moveWithoutTarget sendFrameWithCell:cell withEnvironment:environment];
	}
}

@end

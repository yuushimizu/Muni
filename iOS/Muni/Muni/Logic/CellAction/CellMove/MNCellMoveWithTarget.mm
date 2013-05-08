#import "MNCellMoveWithTarget.h"
#import "JZUtility.h"

@implementation MNCellMoveWithTarget

- (void)resetTargetWithCell:(id<MNCell>)cell Environment:(muni::Environment *)environment {
	std::vector<muni::CellScanningResult> scanningResults = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
		return _targetCondition(cell, candidate);
	} withEnvironment:environment];
	_target = scanningResults.size() > 0 ? scanningResults[0].cell() : nil;
	if (_target) [self foundNewTarget:_target];
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget {
	if (self = [super init]) {
		_targetCondition = condition;
		_moveWithoutTarget = moveWihtoutTarget;
	}
	return self;
}

- (void)foundNewTarget:(id<MNCell>)target {
}

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment {
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	if (!_target || !_target.living) {
		[self resetTargetWithCell:cell Environment:environment];
	} else if (juiz::vector(cell.center, _target.center).magnitude() - cell.radius - _target.radius > cell.sight) {
		[self resetTargetWithCell:cell Environment:environment];
	}
	if (_target) {
		[self sendFrameWithCell:cell withTarget:_target withEnvironment:environment];
	} else {
		[_moveWithoutTarget sendFrameWithCell:cell withEnvironment:environment];
	}
}

@end

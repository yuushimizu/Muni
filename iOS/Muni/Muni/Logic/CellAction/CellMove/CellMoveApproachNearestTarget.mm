#import "CellMoveApproachNearestTarget.h"

namespace muni {
	CellMoveApproachNearestTarget::CellMoveApproachNearestTarget(TargetConditionFunction condition, std::shared_ptr<CellAction> action_without_target) : CellMoveWithNearestTarget(condition, action_without_target) {
	}
	
	void CellMoveApproachNearestTarget::send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
		[cell rotateTowards:target.center];
		[cell moveTowards:target.center];
	}
}
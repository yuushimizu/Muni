#import "CellMoveApproachTarget.h"

namespace muni {
	CellMoveApproachTarget::CellMoveApproachTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target) : CellMoveWithTarget(target_condition, action_without_target) {
	}
	
	void CellMoveApproachTarget::send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
		[cell rotateTowards:target.center];
		[cell moveTowards:target.center];
	}
}
#import "CellMoveWithTarget.h"

namespace muni {
	CellMoveWithTarget::CellMoveWithTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target) : target_condition_(target_condition), action_without_target_(action_without_target) {
	}
	
	void CellMoveWithTarget::found_new_target(id<MNCell> target) {
	}
	
	void CellMoveWithTarget::send_frame(id<MNCell> cell, Environment &environment) {
		if (!target_ || !target_.living || ![cell canSee:target_]) {
			std::vector<muni::CellScanningResult> scanning_results = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
				return (BOOL) target_condition_(cell, candidate);
			} withEnvironment:&environment];
			if (scanning_results.size() > 0) {
				target_ = scanning_results[0].cell();
				found_new_target(target_);
			} else {
				target_ = nil;
			}
		}
		if (target_) {
			send_frame(cell, target_, environment);
		} else {
			action_without_target_->send_frame(cell, environment);
		}
	}
}
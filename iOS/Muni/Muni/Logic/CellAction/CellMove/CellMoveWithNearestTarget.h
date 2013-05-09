#ifndef __Muni__CellMoveWithNearestTarget__
#define __Muni__CellMoveWithNearestTarget__

#import "CellAction.h"
#import "MNCell.h"
#import <memory>

namespace muni {
	template <typename TargetConditionFunction>
	class CellMoveWithNearestTarget : public CellAction {
	private:
		TargetConditionFunction target_condition_;
		std::shared_ptr<CellAction> action_without_target_;
	public:
		CellMoveWithNearestTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target) : target_condition_(target_condition), action_without_target_(action_without_target) {
		}
		
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) = 0;
		
		virtual void send_frame(id<MNCell> cell, Environment &environment) {
			std::vector<CellScanningResult> scanning_results = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
				return (BOOL) target_condition_(cell, candidate);
			} withEnvironment:&environment];
			if (scanning_results.size() > 0) {
				send_frame(cell, scanning_results[0].cell(), environment);
			} else {
				action_without_target_->send_frame(cell, environment);
			}
		}
	};
}

#endif /* defined(__Muni__CellMoveWithNearestTarget__) */

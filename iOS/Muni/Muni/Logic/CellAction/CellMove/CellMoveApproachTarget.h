#ifndef __Muni__CellMoveApproachTarget__
#define __Muni__CellMoveApproachTarget__

#import "CellMoveWithTarget.h"
#import "MNCell.h"

namespace muni {
	template <typename TargetConditionFunction>
	class CellMoveApproachTarget : public CellMoveWithTarget<TargetConditionFunction> {
	public:
		CellMoveApproachTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target) : CellMoveWithTarget<TargetConditionFunction>(target_condition, action_without_target) {
		}
		
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
			[cell rotateTowards:target.center];
			[cell moveTowards:target.center];
		}
	};
}

#endif /* defined(__Muni__CellMoveApproachTarget__) */
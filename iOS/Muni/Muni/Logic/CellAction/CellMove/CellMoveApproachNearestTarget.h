#ifndef __Muni__CellMoveApproachNearestTarget__
#define __Muni__CellMoveApproachNearestTarget__

#import "CellMoveWithNearestTarget.h"
#import "MNCell.h"

namespace muni {
	template<typename TargetConditionFunction>
	class CellMoveApproachNearestTarget : public CellMoveWithNearestTarget<TargetConditionFunction> {
	public:
		CellMoveApproachNearestTarget(TargetConditionFunction condition, std::shared_ptr<CellAction> action_without_target) : CellMoveWithNearestTarget<TargetConditionFunction>(condition, action_without_target) {
		}
		
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
			[cell rotateTowards:target.center];
			[cell moveTowards:target.center];
		}
	};
}

#endif /* defined(__Muni__CellMoveApproachNearestTarget__) */
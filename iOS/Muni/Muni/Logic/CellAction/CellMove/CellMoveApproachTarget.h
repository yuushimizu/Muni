#ifndef __Muni__CellMoveApproachTarget__
#define __Muni__CellMoveApproachTarget__

#import "CellMoveWithTarget.h"
#import "MNCell.h"

namespace muni {
	class CellMoveApproachTarget : public CellMoveWithTarget {
	public:
		CellMoveApproachTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target);
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveApproachTarget__) */
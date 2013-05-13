#ifndef __Muni__CellMoveApproachNearestTarget__
#define __Muni__CellMoveApproachNearestTarget__

#import "CellMoveWithNearestTarget.h"
#import "MNCell.h"

namespace muni {
	class CellMoveApproachNearestTarget : public CellMoveWithNearestTarget {
	public:
		CellMoveApproachNearestTarget(TargetConditionFunction condition, std::shared_ptr<CellAction> action_without_target);
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveApproachNearestTarget__) */
#ifndef __Muni__CellMoveWithNearestTarget__
#define __Muni__CellMoveWithNearestTarget__

#import "CellAction.h"
#import "MNCell.h"
#import <memory>
#import <functional>

namespace muni {
	class CellMoveWithNearestTarget : public CellAction {
	public:
		typedef std::function<bool(id<MNCell>, id<MNCell>)> TargetConditionFunction;
	private:
		TargetConditionFunction target_condition_;
		std::shared_ptr<CellAction> action_without_target_;
	public:
		CellMoveWithNearestTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target);
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) = 0;
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveWithNearestTarget__) */

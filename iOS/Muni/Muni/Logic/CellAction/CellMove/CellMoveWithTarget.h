#ifndef __Muni__CellMoveWithTarget__
#define __Muni__CellMoveWithTarget__

#import "CellAction.h"
#import "MNCell.h"
#import <memory>
#import <functional>

namespace muni {
	class CellMoveWithTarget : public CellAction {
	public:
		typedef std::function<bool(id<MNCell>, id<MNCell>)> TargetConditionFunction;
	private:
		id<MNCell> target_;
		TargetConditionFunction target_condition_;
		std::shared_ptr<CellAction> action_without_target_;
	public:
		CellMoveWithTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target);
		virtual void found_new_target(id<MNCell> target);
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) = 0;
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveWithTarget__) */
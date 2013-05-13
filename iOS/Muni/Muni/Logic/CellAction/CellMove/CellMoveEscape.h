#ifndef __Muni__CellMoveEscape__
#define __Muni__CellMoveEscape__

#import "CellAction.h"
#import "MNCell.h"
#import "MNUtility.h"
#import <memory>
#import <functional>

namespace muni {
	class CellMoveEscape : public CellAction {
	public:
		typedef std::function<bool(id<MNCell>, id<MNCell>)> EscapeConditionFunction;
	private:
		EscapeConditionFunction escape_condition_;
		std::shared_ptr<CellAction> action_when_not_escape_;
	public:
		CellMoveEscape(EscapeConditionFunction escape_condition, std::shared_ptr<CellAction> action_when_not_escape);
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveEscape__) */
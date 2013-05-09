#ifndef __Muni__CellActionConditional__
#define __Muni__CellActionConditional__

#import "CellAction.h"
#import <memory>

namespace muni {
	template <typename ConditionFunction>
	class CellActionConditional : public CellAction {
	private:
		ConditionFunction condition_;
		std::shared_ptr<CellAction> true_action_;
		std::shared_ptr<CellAction> false_action_;
	public:
		CellActionConditional(ConditionFunction condition, std::shared_ptr<CellAction> true_action, std::shared_ptr<CellAction> false_action) : condition_(condition), true_action_(true_action), false_action_(false_action) {
		}
		
		virtual void send_frame(id<MNCell> cell, Environment &environment) {
			(condition_(cell) ? true_action_ : false_action_)->send_frame(cell, environment);
		}
	};
}

#endif /* defined(__Muni__CellActionConditional__) */
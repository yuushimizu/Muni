#ifndef __Muni__CellActionConditional__
#define __Muni__CellActionConditional__

#import "CellAction.h"
#import <memory>
#import <functional>

namespace muni {
	class CellActionConditional : public CellAction {
	public:
		typedef std::function<bool(id<MNCell>)> ConditionFunction;
	private:
		ConditionFunction condition_;
		std::shared_ptr<CellAction> true_action_;
		std::shared_ptr<CellAction> false_action_;
	public:
		CellActionConditional(ConditionFunction condition, std::shared_ptr<CellAction> true_action, std::shared_ptr<CellAction> false_action);
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellActionConditional__) */
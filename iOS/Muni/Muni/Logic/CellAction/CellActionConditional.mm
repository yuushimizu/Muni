#import "CellActionConditional.h"

namespace muni {
	CellActionConditional::CellActionConditional(ConditionFunction condition, std::shared_ptr<CellAction> true_action, std::shared_ptr<CellAction> false_action) : condition_(condition), true_action_(true_action), false_action_(false_action) {
	}
	
	void CellActionConditional::send_frame(id<MNCell> cell, Environment &environment) {
		(condition_(cell) ? true_action_ : false_action_)->send_frame(cell, environment);
	}
}
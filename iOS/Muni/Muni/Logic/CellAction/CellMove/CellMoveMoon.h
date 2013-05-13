#ifndef __Muni__CellMoveMoon__
#define __Muni__CellMoveMoon__

#import "CellMoveWithTarget.h"

namespace muni {
	class CellMoveMoon : public CellMoveWithTarget {
	private:
		const double distance_;
		const double radian_increase_;
	public:
		CellMoveMoon(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target, const double distance, const double radian_increase);
		void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveMoon__) */
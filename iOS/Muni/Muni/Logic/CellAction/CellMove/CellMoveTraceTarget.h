#ifndef __Muni__CellMoveTraceTarget__
#define __Muni__CellMoveTraceTarget__

#import "CellMoveWithTarget.h"
#import "juiz.h"
#import <queue>

namespace muni {
	class CellMoveTraceTarget : public CellMoveWithTarget {
	private:
		const int interval_frames_;
		std::queue<juiz::Point> positions_of_target;
	public:
		CellMoveTraceTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target, const double interval_frames);
		virtual void found_new_target(id<MNCell> target);
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveTraceTarget__) */
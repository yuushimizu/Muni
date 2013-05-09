#ifndef __Muni__CellMoveTraceTarget__
#define __Muni__CellMoveTraceTarget__

#import "CellMoveWithTarget.h"
#import "juiz.h"
#import <queue>

namespace muni {
	template <typename TargetConditionFunction>
	class CellMoveTraceTarget : public CellMoveWithTarget<TargetConditionFunction> {
	private:
		const int interval_frames_;
		std::queue<juiz::Point> positions_of_target;
	public:
		CellMoveTraceTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target, const double interval_frames) : CellMoveWithTarget<TargetConditionFunction>(target_condition, action_without_target), interval_frames_(interval_frames), positions_of_target() {
		}
		
		virtual void found_new_target(id<MNCell> target) {
			positions_of_target = std::queue<juiz::Point>();
			for (int i = -1; i < interval_frames_; ++i) positions_of_target.push(target.center);
		}
		
		virtual void send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
			const juiz::Point next_position = positions_of_target.front();
			if (target.center != next_position) {
				positions_of_target.pop();
				positions_of_target.push(target.center);
				[cell rotateTowards:next_position];
				[cell moveTowards:next_position];
			}
		}
	};
}

#endif /* defined(__Muni__CellMoveTraceTarget__) */
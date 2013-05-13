#import "CellMoveTraceTarget.h"

namespace muni {
	CellMoveTraceTarget::CellMoveTraceTarget(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target, const double interval_frames) : CellMoveWithTarget(target_condition, action_without_target), interval_frames_(interval_frames), positions_of_target() {
	}
	
	void CellMoveTraceTarget::found_new_target(id<MNCell> target) {
		positions_of_target = std::queue<juiz::Point>();
		for (int i = -1; i < interval_frames_; ++i) positions_of_target.push(target.center);
	}
	
	void CellMoveTraceTarget::send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
		const juiz::Point next_position = positions_of_target.front();
		if (target.center != next_position) {
			positions_of_target.pop();
			positions_of_target.push(target.center);
			[cell rotateTowards:next_position];
			[cell moveTowards:next_position];
		}
	}
}
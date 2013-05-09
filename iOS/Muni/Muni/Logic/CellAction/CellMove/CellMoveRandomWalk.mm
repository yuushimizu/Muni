#import "CellMoveRandomWalk.h"
#import "MNUtility.h"

namespace muni {
	CellMoveRandomWalk::CellMoveRandomWalk(const int max_interval_frames) : destination_(), max_interval_frames_(max_interval_frames), rest_interval_frames_(0) {
	}
	
	void CellMoveRandomWalk::send_frame(id<MNCell> cell, Environment &environment) {
		if (rest_interval_frames_ == 0) {
			destination_ = MNRandomPointInSize(environment.field().size());
			rest_interval_frames_ = max_interval_frames_ * MNRandomDouble(0.5, 1.0);
			[cell stop];
		} else if (juiz::vector(cell.center, destination_).magnitude() <= cell.radius) {
			rest_interval_frames_--;
			[cell stop];
		} else {
			[cell rotateTowards:destination_];
			[cell moveTowards:destination_];
		}
	}
}

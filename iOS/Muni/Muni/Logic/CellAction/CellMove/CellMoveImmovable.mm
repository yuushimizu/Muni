#import "CellMoveImmovable.h"

namespace muni {
	void CellMoveImmovable::send_frame(id<MNCell> cell, Environment &environment) {
		[cell stop];
	}
}


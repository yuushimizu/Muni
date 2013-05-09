#import "CellMoveFloat.h"
#import "MNUtility.h"

namespace muni {
	void CellMoveFloat::send_frame(id<MNCell> cell, Environment &environment) {
		[cell moveFor:MNRandomRadian()];
	}
}

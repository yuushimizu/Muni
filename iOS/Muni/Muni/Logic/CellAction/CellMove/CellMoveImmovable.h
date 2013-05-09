#ifndef __Muni__CellMoveImmovable__
#define __Muni__CellMoveImmovable__

#import "CellAction.h"
#import "MNCell.h"

namespace muni {
	class CellMoveImmovable : public CellAction {
	public:
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveImmovable__) */
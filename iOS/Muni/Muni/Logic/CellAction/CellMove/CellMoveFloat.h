#ifndef __Muni__CellMoveFloat__
#define __Muni__CellMoveFloat__

#import "CellAction.h"
#import "MNCell.h"

namespace muni {
	class CellMoveFloat : public CellAction {
	public:
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveFloat__) */
#ifndef __Muni__CellMoveRandomWalk__
#define __Muni__CellMoveRandomWalk__

#import "juiz.h"
#import "CellAction.h"
#import "MNCell.h"

namespace muni {
	class CellMoveRandomWalk : public CellAction {
	private:
		juiz::Point destination_;
		const int max_interval_frames_;
		int rest_interval_frames_;
	public:
		CellMoveRandomWalk(const int max_interval_frames);
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellMoveRandomWalk__) */
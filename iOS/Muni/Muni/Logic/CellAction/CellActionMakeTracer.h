#ifndef __Muni__CellActionMakeTracer__
#define __Muni__CellActionMakeTracer__

#import "CellAction.h"
#import "MNCell.h"

namespace muni {
	class CellActionMakeTracer : public CellAction {
	private:
		bool generated_;
		const int interval_frames_;
		const double incidence_;
	public:
		CellActionMakeTracer(const int interval_frames, const double incidence);
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellActionMakeTracer__) */
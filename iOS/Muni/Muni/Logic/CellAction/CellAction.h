#ifndef __Muni__CellAction__
#define __Muni__CellAction__

#import "MNCell.h"
#import "Environment.h"

namespace muni {
	class CellAction {
	public:
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellAction__) */

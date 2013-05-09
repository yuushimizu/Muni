#ifndef __Muni__CellActionMultiply__
#define __Muni__CellActionMultiply__

#import "CellAction.h"
#import "MNCell.h"

namespace muni {
	class CellActionMultiply : public CellAction {
	private:
		int rest_count_;
		const double incidence_;
	public:
		CellActionMultiply(const int max_count, const double incidence);
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellActionMultiply__) */
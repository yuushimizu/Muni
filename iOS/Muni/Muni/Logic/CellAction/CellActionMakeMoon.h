#ifndef __Muni__CellActionMakeMoon__
#define __Muni__CellActionMakeMoon__

#import "CellAction.h"
#import "MNCell.h"

namespace muni {
	class CellActionMakeMoon : public CellAction {
	private:
		const double incidence_;
		const double distance_;
		int rest_count_;
		const double radian_increase_;
	public:
		CellActionMakeMoon(const double distance, const double radian_increase, const int max_count, const double incidence);
		virtual void send_frame(id<MNCell> cell, Environment &environment);
	};
}

#endif /* defined(__Muni__CellActionMakeMoon__) */
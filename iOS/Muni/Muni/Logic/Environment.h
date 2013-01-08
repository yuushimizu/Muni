#ifndef __Muni__Environment__
#define __Muni__Environment__

#import <Foundation/Foundation.h>
#include <vector>
#include "juiz.h"
#include "Field.h"

@protocol MNCell;
@class MNCellScanningResult;

namespace muni {
	class Environment {
	public:
		virtual const Field field() const = 0;
		virtual const std::vector<id<MNCell> > cells() const = 0;
		virtual void send_frame() = 0;
		virtual void add_cell(id<MNCell> cell) = 0;
		virtual const std::vector<MNCellScanningResult *> cells_in_circle(const juiz::Point &center, const double radius, BOOL (^confition)(id<MNCell> other)) = 0;
	};
}

#endif /* defined(__Muni__Environment__) */

#ifndef __Muni__Environment__
#define __Muni__Environment__

#import <Foundation/Foundation.h>
#import <vector>
#import "juiz.h"
#import "Field.h"
#import "CellScanningResult.h"

@protocol MNCell;

namespace muni {
	class Environment {
	public:
		virtual const Field field() const = 0;
		virtual const std::vector<id<MNCell> > cells() const = 0;
		virtual void send_frame() = 0;
		virtual void add_cell(id<MNCell> cell) = 0;
		virtual const std::vector<CellScanningResult> cells_in_circle(const juiz::Point &center, const double radius, BOOL (^confition)(id<MNCell> other)) = 0;
	};
}

#endif /* defined(__Muni__Environment__) */

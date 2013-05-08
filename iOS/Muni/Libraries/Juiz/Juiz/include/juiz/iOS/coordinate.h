#ifndef __Juiz__ios__coordinate__
#define __Juiz__ios__coordinate__

#import <UIKit/UIKit.h>

namespace juiz {
	namespace coordinate {
		class Point;
		class Size;
	}
	namespace ios {
		namespace coordinate {
			const CGPoint cgPoint(const juiz::coordinate::Point &point);
			const juiz::coordinate::Point point(const CGPoint &cgPoint);
			const CGSize cgSize(const juiz::coordinate::Size &siez);
			const juiz::coordinate::Size size(const CGSize &cgSize);
		}
	}
}

#endif

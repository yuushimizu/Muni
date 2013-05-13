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
			CGPoint cgPoint(const juiz::coordinate::Point &point);
			juiz::coordinate::Point point(const CGPoint &cgPoint);
			CGSize cgSize(const juiz::coordinate::Size &siez);
			juiz::coordinate::Size size(const CGSize &cgSize);
		}
	}
}

#endif

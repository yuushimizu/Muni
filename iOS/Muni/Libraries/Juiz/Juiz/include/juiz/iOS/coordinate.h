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
			const CGPoint cgPointFromPoint(const juiz::coordinate::Point &point);
			const juiz::coordinate::Point pointFromCGPoint(const CGPoint &cgPoint);
			const CGSize cgSizeFromSize(const juiz::coordinate::Size &size);
			const juiz::coordinate::Size sizeFromCGSize(const CGSize &cgSize);
		}
	}
}

#endif /* defined(__Juiz__ios__coordinate__) */

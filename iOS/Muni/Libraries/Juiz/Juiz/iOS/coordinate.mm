#import "juiz/ios/coordinate.h"
#import "juiz/coordinate/Point.h"
#import "juiz/coordinate/Size.h"

namespace juiz {
	namespace ios {
		namespace coordinate {
			const CGPoint cgPointFromPoint(const juiz::coordinate::Point &point) {
				return CGPointMake(point.x(), point.y());
			}
			
			const juiz::coordinate::Point pointFromCGPoint(const CGPoint &cgPoint) {
				return juiz::coordinate::Point(cgPoint.x, cgPoint.y);
			}
			
			const CGSize cgSizeFromSize(const juiz::coordinate::Size &size) {
				return CGSizeMake(size.width(), size.height());
			}
			
			const juiz::coordinate::Size sizeFromCGSize(const CGSize &cgSize) {
				return juiz::coordinate::Size(cgSize.width, cgSize.height);
			}
		}
	}
}

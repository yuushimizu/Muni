#import "juiz/ios/coordinate.h"
#import "juiz/coordinate/Point.h"
#import "juiz/coordinate/Size.h"

namespace juiz {
	namespace ios {
		namespace coordinate {
			CGPoint cgPoint(const juiz::coordinate::Point &point) {
				return CGPointMake(point.x(), point.y());
			}
			
			juiz::coordinate::Point point(const CGPoint &cgPoint) {
				return juiz::coordinate::Point(cgPoint.x, cgPoint.y);
			}
			
			CGSize cgSize(const juiz::coordinate::Size &size) {
				return CGSizeMake(size.width(), size.height());
			}
			
			juiz::coordinate::Size size(const CGSize &cgSize) {
				return juiz::coordinate::Size(cgSize.width, cgSize.height);
			}
		}
	}
}

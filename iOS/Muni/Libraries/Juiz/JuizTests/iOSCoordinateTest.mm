#import "iOSCoordinateTest.h"
#import "TestUtility.h"

@implementation CoordinateIOSTest

const CGPoint cgPointFromPoint(const juiz::coordinate::Point &point);
const juiz::coordinate::Point pointFromCGPoint(const CGPoint &cgPoint);
const CGSize cgSizeFromSize(const juiz::coordinate::Size &size);
const juiz::coordinate::Size sizeFromCGSize(const CGSize &cgSize);

- (void)testCGPointFromPoint {
	STAssertTrue(CGPointEqualToPoint(CGPointMake(5.9, 8.1), juiz::cgPointFromPoint(juiz::Point(5.9, 8.1))), @"");
	STAssertTrue(CGPointEqualToPoint(CGPointMake(0, 0), juiz::cgPointFromPoint(juiz::Point(0, 0))), @"");
}

- (void)testPointFromCGPoint {
	STAssertTrue(points_are_same(juiz::Point(17.2, 33.1), juiz::pointFromCGPoint(CGPointMake(17.2, 33.1))), @"");
	STAssertTrue(juiz::Point(0, 0) == juiz::pointFromCGPoint(CGPointMake(0, 0)), @"");
}

- (void)testCGSizeFromSize {
	STAssertTrue(CGSizeEqualToSize(CGSizeMake(5.9, 8.1), juiz::cgSizeFromSize(juiz::Size(5.9, 8.1))), @"");
	STAssertTrue(CGSizeEqualToSize(CGSizeMake(0, 0), juiz::cgSizeFromSize(juiz::Size(0, 0))), @"");
}

- (void)testSizeFromCGSize {
	STAssertTrue(sizes_are_same(juiz::Size(17.2, 33.1), juiz::sizeFromCGSize(CGSizeMake(17.2, 33.1))), @"");
	STAssertTrue(juiz::Size(0, 0) == juiz::sizeFromCGSize(CGSizeMake(0, 0)), @"");
}

@end

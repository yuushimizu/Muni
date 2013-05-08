#import "iOSCoordinateTest.h"
#import "TestUtility.h"

@implementation CoordinateIOSTest

- (void)testCGPointFromPoint {
	STAssertTrue(CGPointEqualToPoint(CGPointMake(5.9, 8.1), juiz::cgPoint(juiz::Point(5.9, 8.1))), @"");
	STAssertTrue(CGPointEqualToPoint(CGPointMake(0, 0), juiz::cgPoint(juiz::Point(0, 0))), @"");
}

- (void)testPointFromCGPoint {
	STAssertTrue(roughly_equal(juiz::Point(17.2, 33.1), juiz::point(CGPointMake(17.2, 33.1))), @"");
	STAssertTrue(juiz::Point(0, 0) == juiz::point(CGPointMake(0, 0)), @"");
}

- (void)testCGSizeFromSize {
	STAssertTrue(CGSizeEqualToSize(CGSizeMake(5.9, 8.1), juiz::cgSize(juiz::Size(5.9, 8.1))), @"");
	STAssertTrue(CGSizeEqualToSize(CGSizeMake(0, 0), juiz::cgSize(juiz::Size(0, 0))), @"");
}

- (void)testSizeFromCGSize {
	STAssertTrue(roughly_equal(juiz::Size(17.2, 33.1), juiz::size(CGSizeMake(17.2, 33.1))), @"");
	STAssertTrue(juiz::Size(0, 0) == juiz::size(CGSizeMake(0, 0)), @"");
}

@end

#import "CoordinateTest.h"
#import "TestUtility.h"

@implementation CoordinateTest

- (void)testPointIntervalOfPoints {
	STAssertEquals(juiz::PointInterval(8, 13), juiz::point_interval_of_points(juiz::Point(0, 0), juiz::Point(8, 13)), @"");
	STAssertEquals(juiz::PointInterval(104, 55), juiz::point_interval_of_points(juiz::Point(48, 111), juiz::Point(152, 166)), @"");
	STAssertEquals(juiz::PointInterval(-5, -2), juiz::point_interval_of_points(juiz::Point(7, 9), juiz::Point(2, 7)), @"");
	STAssertEquals(juiz::PointInterval(0, 0), juiz::point_interval_of_points(juiz::Point(88, 312), juiz::Point(88, 312)), @"");
}

- (void)testAddPointIntervalToPoint {
	STAssertEquals(juiz::Point(62, 34), juiz::add_point_interval_to_point(juiz::Point(12, 33), juiz::PointInterval(50, 1)), @"");
	STAssertEquals(juiz::Point(7, 9), juiz::add_point_interval_to_point(juiz::Point(102, 338), juiz::PointInterval(-95, -329)), @"");
}

- (void)testPointIntervalFromVector {
	STAssertTrue(point_intervals_are_same(juiz::PointInterval(0.0, 30.0), juiz::point_interval_from_vector(juiz::Vector(0.0, 30.0))), @"");
	STAssertTrue(point_intervals_are_same(juiz::PointInterval(24.2, 0.0), juiz::point_interval_from_vector(juiz::Vector(M_PI_2, 24.2))), @"");
	STAssertTrue(point_intervals_are_same(juiz::PointInterval(0.0, -12.3), juiz::point_interval_from_vector(juiz::Vector(M_PI, 12.3))), @"");
	STAssertTrue(point_intervals_are_same(juiz::PointInterval(-56.99, 0.0), juiz::point_interval_from_vector(juiz::Vector(-M_PI_2, 56.99))), @"");
	STAssertTrue(point_intervals_are_same(juiz::PointInterval(1, 1), juiz::point_interval_from_vector(juiz::Vector(M_PI_4, sqrt(2)))), @"");
}

- (void)testVectorFromPointInterval {
	STAssertEquals(juiz::Vector(0.0, 30.0), juiz::vector_from_point_interval(juiz::PointInterval(0.0, 30.0)), @"");
	STAssertEquals(juiz::Vector(M_PI_2, 24.2), juiz::vector_from_point_interval(juiz::PointInterval(24.2, 0.0)), @"");
	STAssertEquals(juiz::Vector(M_PI, 12.3), juiz::vector_from_point_interval(juiz::PointInterval(0.0, -12.3)), @"");
	STAssertEquals(juiz::Vector(-M_PI_2, 56.99), juiz::vector_from_point_interval(juiz::PointInterval(-56.99, 0.0)), @"");
	STAssertEquals(juiz::Vector(M_PI_4, sqrt(2)), juiz::vector_from_point_interval(juiz::PointInterval(1, 1)), @"");
}

- (void)testInvertAngle {
	STAssertEquals(M_PI, juiz::invert_angle(0), @"");
	STAssertEquals(0.0, juiz::invert_angle(M_PI), @"");
	STAssertEquals(M_PI + 1.2, juiz::invert_angle(1.2), @"");
	STAssertTrue(doubles_in_allowable_range(1.2, juiz::invert_angle(M_PI + 1.2)), @"");
}

@end

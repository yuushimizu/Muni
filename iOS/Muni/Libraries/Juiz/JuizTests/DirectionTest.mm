#import "DirectionTest.h"
#import "TestUtility.h"

@implementation DirectionTest

- (void)testDefaultConstructor {
	STAssertEquals(0.0, juiz::Direction().clockwise_angle_with_above(), @"");
}

- (void)testClockwiseAngleWithAbove {
	STAssertEquals(0.0, juiz::Direction(0.0).clockwise_angle_with_above(), @"");
	STAssertEquals(1.53, juiz::Direction(1.53).clockwise_angle_with_above(), @"");
	STAssertEquals(-1.53 + M_PI * 2, juiz::Direction(-1.53).clockwise_angle_with_above(), @"");
}

- (void)testCopyConstructor {
	const juiz::Direction direction1(1.23);
	const juiz::Direction direction2 = direction1;
	STAssertEquals(juiz::Direction(1.23), direction2, @"");
	const juiz::Direction direction3 = juiz::Direction(2.11);
	STAssertEquals(juiz::Direction(2.11), direction3, @"");
}

- (void)testOperatorAssign {
	juiz::Direction direction(1.24);
	direction = juiz::Direction(2.35);
	STAssertEquals(juiz::Direction(2.35), direction, @"");
	direction = juiz::Direction(0.038);
	STAssertEquals(juiz::Direction(0.038), direction, @"");
}

- (void)testOperatorEqual {
	STAssertTrue(juiz::Direction(0.0) == juiz::Direction(0.0), @"");
	STAssertTrue(juiz::Direction(1.993) == juiz::Direction(1.993), @"");
	STAssertTrue(juiz::Direction(-1.81 + M_PI * 2) == juiz::Direction(-1.81), @"");
	STAssertFalse(juiz::Direction(0.0) == juiz::Direction(0.001), @"");
	STAssertFalse(juiz::Direction(1.993) == juiz::Direction(1.996), @"");
	STAssertFalse(juiz::Direction(-1.83 + M_PI * 2) == juiz::Direction(-1.81), @"");
}

- (void)testOperatorNotEqual {
	STAssertFalse(juiz::Direction(0.0) != juiz::Direction(0.0), @"");
	STAssertFalse(juiz::Direction(1.993) != juiz::Direction(1.993), @"");
	STAssertFalse(juiz::Direction(-1.81 + M_PI * 2) != juiz::Direction(-1.81), @"");
	STAssertTrue(juiz::Direction(0.0) != juiz::Direction(0.001), @"");
	STAssertTrue(juiz::Direction(1.993) != juiz::Direction(1.996), @"");
	STAssertTrue(juiz::Direction(-1.83 + M_PI * 2) != juiz::Direction(-1.81), @"");
}

- (void)testRotateClockwise {
	AssertRoughlyEqual(juiz::Direction(2.0), juiz::rotate_clockwise(juiz::Direction(0.0), 2.0), @"");
	AssertRoughlyEqual(juiz::Direction(1.34), juiz::rotate_clockwise(juiz::Direction(0.72), 0.62), @"");
	AssertRoughlyEqual(juiz::Direction(1.992), juiz::rotate_clockwise(juiz::Direction(1.992), M_PI * 2), @"");
	AssertRoughlyEqual(juiz::Direction(0.1), juiz::rotate_clockwise(juiz::Direction(0.1), 0), @"");
	AssertRoughlyEqual(juiz::Direction(0.22 + M_PI), juiz::rotate_clockwise(juiz::Direction(0.22), M_PI), @"");
	AssertRoughlyEqual(juiz::Direction(0.42), juiz::rotate_clockwise(juiz::Direction(0.82), -0.4), @"");
	AssertRoughlyEqual(juiz::Direction(1.5), juiz::rotate_clockwise(juiz::Direction(0), 1.5), @"");
	AssertRoughlyEqual(juiz::Direction(1.0), juiz::rotate_clockwise(juiz::Direction(-0.5), 1.5), @"");
	AssertRoughlyEqual(juiz::Direction(0), juiz::rotate_clockwise(juiz::Direction(-0.5), 0.5), @"");
}

- (void)testRotateCounterclockwise {
	AssertRoughlyEqual(juiz::Direction(-2.0), juiz::rotate_counterclockwise(juiz::Direction(0.0), 2.0), @"");
	AssertRoughlyEqual(juiz::Direction(0.62), juiz::rotate_counterclockwise(juiz::Direction(1.34), 0.72), @"");
	AssertRoughlyEqual(juiz::Direction(1.87), juiz::rotate_counterclockwise(juiz::Direction(1.87), M_PI * 2), @"");
	AssertRoughlyEqual(juiz::Direction(0.3), juiz::rotate_counterclockwise(juiz::Direction(0.3), 0), @"");
	AssertRoughlyEqual(juiz::Direction(2.45 - M_PI), juiz::rotate_counterclockwise(juiz::Direction(2.45), M_PI), @"");
	AssertRoughlyEqual(juiz::Direction(0.83), juiz::rotate_counterclockwise(juiz::Direction(0.42), -0.41), @"");
	AssertRoughlyEqual(juiz::Direction(-1.4), juiz::rotate_counterclockwise(juiz::Direction(0), 1.4), @"");
	AssertRoughlyEqual(juiz::Direction(-1.5), juiz::rotate_counterclockwise(juiz::Direction(-0.5), 1.0), @"");
	AssertRoughlyEqual(juiz::Direction(0), juiz::rotate_counterclockwise(juiz::Direction(0.5), 0.5), @"");
}

- (void)testInvert {
	AssertRoughlyEqual(juiz::Direction(1.3 + M_PI), juiz::invert(juiz::Direction(1.3)), @"");
	AssertRoughlyEqual(juiz::Direction(M_PI), juiz::invert(juiz::Direction(0)), @"");
	AssertRoughlyEqual(juiz::Direction(0), juiz::invert(juiz::Direction(M_PI)), @"");
	juiz::Direction direction1(1.4);
	AssertRoughlyEqual(juiz::Direction(1.4 + M_PI), juiz::invert(direction1), @"");
	juiz::Direction direction2(0);
	AssertRoughlyEqual(juiz::Direction(M_PI), juiz::invert(direction2), @"");
	juiz::Direction direction3(M_PI);
	AssertRoughlyEqual(juiz::Direction(0), juiz::invert(direction3), @"");
}

- (void)testClockwiseAngle {
	AssertRoughlyEqual(0.5, juiz::clockwise_angle(juiz::Direction(0.32), juiz::Direction(0.82)), @"");
	AssertRoughlyEqual(M_PI, juiz::clockwise_angle(juiz::Direction(1.2), juiz::Direction(1.2 + M_PI)), @"");
	AssertRoughlyEqual(0.0, juiz::clockwise_angle(juiz::Direction(1.89), juiz::Direction(1.89)), @"");
	AssertRoughlyEqual(2.0, juiz::clockwise_angle(juiz::Direction(-1.0), juiz::Direction(1.0)), @"");
	AssertRoughlyEqual(2.0, juiz::clockwise_angle(juiz::Direction(-1.0 + M_PI), juiz::Direction(1.0 + M_PI)), @"");
	AssertRoughlyEqual(M_PI * 2 - 1.33, juiz::clockwise_angle(juiz::Direction(2.78), juiz::Direction(1.45)), @"");
	AssertRoughlyEqual(3.71, juiz::clockwise_angle(juiz::Direction(0), juiz::Direction(3.71)), @"");
	AssertRoughlyEqual(M_PI * 2 - 2.48, juiz::clockwise_angle(juiz::Direction(2.48), juiz::Direction(0)), @"");
}

- (void)testCounterclockwiseAngle {
	AssertRoughlyEqual(0.5, juiz::counterclockwise_angle(juiz::Direction(0.82), juiz::Direction(0.32)), @"");
	AssertRoughlyEqual(M_PI, juiz::counterclockwise_angle(juiz::Direction(1.2 + M_PI), juiz::Direction(1.2)), @"");
	AssertRoughlyEqual(0.0, juiz::counterclockwise_angle(juiz::Direction(1.89), juiz::Direction(1.89)), @"");
	AssertRoughlyEqual(2.0, juiz::counterclockwise_angle(juiz::Direction(1.0), juiz::Direction(-1.0)), @"");
	AssertRoughlyEqual(2.0, juiz::counterclockwise_angle(juiz::Direction(1.0 + M_PI), juiz::Direction(-1.0 + M_PI)), @"");
	AssertRoughlyEqual(M_PI * 2 - 1.33, juiz::counterclockwise_angle(juiz::Direction(1.45), juiz::Direction(2.78)), @"");
	AssertRoughlyEqual(3.71, juiz::counterclockwise_angle(juiz::Direction(3.71), juiz::Direction(0)), @"");
	AssertRoughlyEqual(M_PI * 2 - 2.48, juiz::counterclockwise_angle(juiz::Direction(0), juiz::Direction(2.48)), @"");
}

- (void)testClockwiseAngleIsSmall {
	STAssertTrue(juiz::clockwise_angle_is_small(juiz::Direction(0), juiz::Direction(2.4)), @"");
	STAssertTrue(juiz::clockwise_angle_is_small(juiz::Direction(3.2), juiz::Direction(3.6)), @"");
	STAssertTrue(juiz::clockwise_angle_is_small(juiz::Direction(0), juiz::Direction(M_PI - 0.001)), @"");
	STAssertTrue(juiz::clockwise_angle_is_small(juiz::Direction(-1.2), juiz::Direction(0)), @"");
	STAssertFalse(juiz::clockwise_angle_is_small(juiz::Direction(0), juiz::Direction(5.6)), @"");
	STAssertFalse(juiz::clockwise_angle_is_small(juiz::Direction(3.6), juiz::Direction(3.2)), @"");
	STAssertFalse(juiz::clockwise_angle_is_small(juiz::Direction(0), juiz::Direction(M_PI + 0.001)), @"");
	STAssertFalse(juiz::clockwise_angle_is_small(juiz::Direction(0), juiz::Direction(-1.2)), @"");
}

- (void)testConstants {
	STAssertEquals(juiz::directions::ABOVE, juiz::Direction(0), @"");
	STAssertEquals(juiz::directions::RIGHT, juiz::Direction(M_PI_2), @"");
	STAssertEquals(juiz::directions::BELOW, juiz::Direction(M_PI), @"");
	STAssertEquals(juiz::directions::LEFT, juiz::Direction(M_PI + M_PI_2), @"");
	AssertRoughlyEqual(juiz::directions::ABOVE, juiz::rotate_clockwise(juiz::directions::LEFT, M_PI_2), @"");
	AssertRoughlyEqual(juiz::directions::RIGHT, juiz::rotate_clockwise(juiz::directions::ABOVE, M_PI_2), @"");
	AssertRoughlyEqual(juiz::directions::BELOW, juiz::rotate_clockwise(juiz::directions::RIGHT, M_PI_2), @"");
	AssertRoughlyEqual(juiz::directions::LEFT, juiz::rotate_clockwise(juiz::directions::BELOW, M_PI_2), @"");
}

@end

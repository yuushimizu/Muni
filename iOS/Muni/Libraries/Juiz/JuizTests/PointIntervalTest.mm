#import "PointIntervalTest.h"

@implementation PointIntervalTest

- (void)testDefaultConstructor {
	STAssertEquals(0.0, juiz::PointInterval().x(), @"");
	STAssertEquals(0.0, juiz::PointInterval().y(), @"");
}

- (void)testX {
	STAssertEquals(1.5, juiz::PointInterval(1.5, 2.3).x(), @"");
	STAssertEquals(3.1, juiz::PointInterval(3.1, 1.9).x(), @"");
}

- (void)testY {
	STAssertEquals(2.3, juiz::PointInterval(1.5, 2.3).y(), @"");
	STAssertEquals(1.9, juiz::PointInterval(3.1, 1.9).y(), @"");
}

- (void)testSetX {
	juiz::PointInterval pointInterval1(10.5, 3.44);
	STAssertEquals(10.5, pointInterval1.x(), @"");
	pointInterval1.x(18.77);
	STAssertEquals(18.77, pointInterval1.x(), @"");
	juiz::PointInterval pointInterval2(8, 1);
	STAssertEquals(8.0, pointInterval2.x(), @"");
	pointInterval2.x(0.0);
	STAssertEquals(0.0, pointInterval2.x(), @"");
}

- (void)testSetY {
	juiz::PointInterval pointInterval1(10.5, 3.44);
	STAssertEquals(3.44, pointInterval1.y(), @"");
	pointInterval1.y(19.12);
	STAssertEquals(19.12, pointInterval1.y(), @"");
	juiz::PointInterval pointInterval2(8, 1);
	STAssertEquals(1.0, pointInterval2.y(), @"");
	pointInterval2.y(0.0);
	STAssertEquals(0.0, pointInterval2.y(), @"");
}


- (void)testOperatorEqual {
	STAssertTrue(juiz::PointInterval(15.7, 20.33) == juiz::PointInterval(15.7, 20.33), @"");
	STAssertFalse(juiz::PointInterval(15.8, 20.34) == juiz::PointInterval(20.34, 15.8), @"");
	STAssertTrue(juiz::PointInterval(5.4, 66.7) == juiz::PointInterval(5.4, 66.7), @"");
	STAssertFalse(juiz::PointInterval(1, 2) == juiz::PointInterval(2, 1), @"");
	STAssertFalse(juiz::PointInterval(30.5, 30.4) == juiz::PointInterval(30.5, 19.1), @"");
	STAssertFalse(juiz::PointInterval(18.55, 21.32) == juiz::PointInterval(18.2, 21.32), @"");
}

- (void)testOperatorNotEqual {
	STAssertFalse(juiz::PointInterval(15.7, 20.33) != juiz::PointInterval(15.7, 20.33), @"");
	STAssertTrue(juiz::PointInterval(15.8, 20.34) != juiz::PointInterval(20.34, 15.8), @"");
	STAssertFalse(juiz::PointInterval(5.4, 66.7) != juiz::PointInterval(5.4, 66.7), @"");
	STAssertTrue(juiz::PointInterval(1, 2) != juiz::PointInterval(2, 1), @"");
	STAssertTrue(juiz::PointInterval(30.5, 30.4) != juiz::PointInterval(30.5, 19.1), @"");
	STAssertTrue(juiz::PointInterval(18.55, 21.32) != juiz::PointInterval(18.2, 21.32), @"");
}

- (void)testCopy {
	const juiz::PointInterval point_interval1(10.6, 30.8);
	const juiz::PointInterval point_interval2 = point_interval1;
	STAssertEquals(juiz::PointInterval(10.6, 30.8), point_interval2, @"");
	const juiz::PointInterval point_interval3 = juiz::PointInterval(8.7, 9.9);
	STAssertEquals(juiz::PointInterval(8.7, 9.9), point_interval3, @"");
}

- (void)testOperatorAssign {
	juiz::PointInterval point_interval(5, 6);
	point_interval = juiz::PointInterval(10, 40);
	STAssertEquals(juiz::PointInterval(10, 40), point_interval, @"");
	point_interval = juiz::PointInterval(93, 21);
	STAssertEquals(juiz::PointInterval(93, 21), point_interval, @"");
}

- (void)testAngleOfPointInterval {
	STAssertEquals(0.0, juiz::angle_of_point_interval(juiz::PointInterval(0, 60)), @"");
	STAssertEquals(M_PI_2, juiz::angle_of_point_interval(juiz::PointInterval(33.5, 0)), @"");
	STAssertEquals(M_PI, juiz::angle_of_point_interval(juiz::PointInterval(0, -15.8)), @"");
	STAssertEquals(-M_PI_2, juiz::angle_of_point_interval(juiz::PointInterval(-71.2, 0)), @"");
	STAssertEquals(M_PI_4, juiz::angle_of_point_interval(juiz::PointInterval(1, 1)), @"");
	STAssertEquals(-M_PI_4, juiz::angle_of_point_interval(juiz::PointInterval(-1, 1)), @"");
}

- (void)testDistanceOfPointInterval {
	STAssertEquals(5.0, juiz::distance_of_point_interval(juiz::PointInterval(3, 4)), @"");
	STAssertEquals(50.0, juiz::distance_of_point_interval(juiz::PointInterval(40, 30)), @"");
	STAssertEquals(5.0, juiz::distance_of_point_interval(juiz::PointInterval(-3, -4)), @"");
	STAssertEquals(5.0, juiz::distance_of_point_interval(juiz::PointInterval(3, -4)), @"");
	STAssertEquals(5.0, juiz::distance_of_point_interval(juiz::PointInterval(-3, 4)), @"");
	STAssertEquals(sqrt(2), juiz::distance_of_point_interval(juiz::PointInterval(1, 1)), @"");
}

@end

#import "PointTest.h"

@implementation PointTest

- (void)testDefaultConstructor {
	STAssertEquals(0.0, juiz::Point().x(), @"");
	STAssertEquals(0.0, juiz::Point().y(), @"");
}

- (void)testX {
	STAssertEquals(1.5, juiz::Point(1.5, 2.3).x(), @"");
	STAssertEquals(3.1, juiz::Point(3.1, 1.9).x(), @"");
}

- (void)testY {
	STAssertEquals(2.3, juiz::Point(1.5, 2.3).y(), @"");
	STAssertEquals(1.9, juiz::Point(3.1, 1.9).y(), @"");
}

- (void)testSetX {
	juiz::Point point1(10.5, 3.44);
	STAssertEquals(10.5, point1.x(), @"");
	point1.x(18.77);
	STAssertEquals(18.77, point1.x(), @"");
	juiz::Point point2(8, 1);
	STAssertEquals(8.0, point2.x(), @"");
	point2.x(0.0);
	STAssertEquals(0.0, point2.x(), @"");
}

- (void)testSetY {
	juiz::Point point1(10.5, 3.44);
	STAssertEquals(3.44, point1.y(), @"");
	point1.y(19.12);
	STAssertEquals(19.12, point1.y(), @"");
	juiz::Point point2(8, 1);
	STAssertEquals(1.0, point2.y(), @"");
	point2.y(0.0);
	STAssertEquals(0.0, point2.y(), @"");
}

- (void)testOperatorEqual {
	STAssertTrue(juiz::Point(15.7, 20.33) == juiz::Point(15.7, 20.33), @"");
	STAssertFalse(juiz::Point(15.8, 20.34) == juiz::Point(20.34, 15.8), @"");
	STAssertTrue(juiz::Point(5.4, 66.7) == juiz::Point(5.4, 66.7), @"");
	STAssertFalse(juiz::Point(1, 2) == juiz::Point(2, 1), @"");
	STAssertFalse(juiz::Point(30.5, 30.4) == juiz::Point(30.5, 19.1), @"");
	STAssertFalse(juiz::Point(18.55, 21.32) == juiz::Point(18.2, 21.32), @"");
}

- (void)testOperatorNotEqual {
	STAssertFalse(juiz::Point(15.7, 20.33) != juiz::Point(15.7, 20.33), @"");
	STAssertTrue(juiz::Point(15.8, 20.34) != juiz::Point(20.34, 15.8), @"");
	STAssertFalse(juiz::Point(5.4, 66.7) != juiz::Point(5.4, 66.7), @"");
	STAssertTrue(juiz::Point(1, 2) != juiz::Point(2, 1), @"");
	STAssertTrue(juiz::Point(30.5, 30.4) != juiz::Point(30.5, 19.1), @"");
	STAssertTrue(juiz::Point(18.55, 21.32) != juiz::Point(18.2, 21.32), @"");
}

- (void)testCopy {
	const juiz::Point point1(10.6, 30.8);
	const juiz::Point point2 = point1;
	STAssertEquals(juiz::Point(10.6, 30.8), point2, @"");
	const juiz::Point point3 = juiz::Point(8.7, 9.9);
	STAssertEquals(juiz::Point(8.7, 9.9), point3, @"");
}

- (void)testOperatorAssign {
	juiz::Point point(5, 6);
	point = juiz::Point(10, 40);
	STAssertEquals(juiz::Point(10, 40), point, @"");
	point = juiz::Point(93, 21);
	STAssertEquals(juiz::Point(93, 21), point, @"");
}

@end

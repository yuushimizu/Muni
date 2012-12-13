#import "VectorTest.h"
#import "TestUtility.h"

@implementation VectorTest

- (void)testDefaultConstructor {
	STAssertEquals(0.0, juiz::Vector().direction(), @"");
	STAssertEquals(0.0, juiz::Vector().magnitude(), @"");
}

- (void)testDirection {
	STAssertEquals(0.582, juiz::Vector(0.582, 55.8).direction(), @"");
	STAssertEquals(1.2281, juiz::Vector(1.2281, 731).direction(), @"");
}

- (void)testMagnitude {
	STAssertEquals(55.8, juiz::Vector(0.582, 55.8).magnitude(), @"");
	STAssertEquals(731.0, juiz::Vector(1.2281, 731).magnitude(), @"");
}

- (void)testSetDirection {
	juiz::Vector vector1(1.2, 50.6);
	STAssertEquals(1.2, vector1.direction(), @"");
	vector1.direction(2.22);
	STAssertEquals(2.22, vector1.direction(), @"");
	juiz::Vector vector2(0.56, 120.1);
	STAssertEquals(0.56, vector2.direction(), @"");
	vector2.direction(0);
	STAssertEquals(0.0, vector2.direction(), @"");
}

- (void)testSetMagnitude {
	juiz::Vector vector1(1.2, 50.6);
	STAssertEquals(50.6, vector1.magnitude(), @"");
	vector1.magnitude(8.3);
	STAssertEquals(8.3, vector1.magnitude(), @"");
	juiz::Vector vector2(0.56, 120.1);
	STAssertEquals(120.1, vector2.magnitude(), @"");
	vector2.magnitude(0);
	STAssertEquals(0.0, vector2.magnitude(), @"");
}

- (void)testOperatorEqual {
	STAssertTrue(juiz::Vector(0.157, 20.33) == juiz::Vector(0.157, 20.33), @"");
	STAssertFalse(juiz::Vector(0.158, 0.2034) == juiz::Vector(0.2034, 0.158), @"");
	STAssertTrue(juiz::Vector(0.54, 66.7) == juiz::Vector(0.54, 66.7), @"");
	STAssertFalse(juiz::Vector(1, 2) == juiz::Vector(2, 1), @"");
	STAssertFalse(juiz::Vector(0.305, 30.4) == juiz::Vector(0.305, 19.1), @"");
	STAssertFalse(juiz::Vector(0.1855, 21.32) == juiz::Vector(0.182, 21.32), @"");
}

- (void)testOperatorNotEqual {
	STAssertFalse(juiz::Vector(0.157, 20.33) != juiz::Vector(0.157, 20.33), @"");
	STAssertTrue(juiz::Vector(0.158, 0.2034) != juiz::Vector(0.2034, 0.158), @"");
	STAssertFalse(juiz::Vector(0.54, 66.7) != juiz::Vector(0.54, 66.7), @"");
	STAssertTrue(juiz::Vector(1, 2) != juiz::Vector(2, 1), @"");
	STAssertTrue(juiz::Vector(0.305, 30.4) != juiz::Vector(0.305, 19.1), @"");
	STAssertTrue(juiz::Vector(0.1855, 21.32) != juiz::Vector(0.182, 21.32), @"");
}

- (void)testCopy {
	const juiz::Vector vector1(1.06, 30.8);
	const juiz::Vector vector2 = vector1;
	STAssertEquals(juiz::Vector(1.06, 30.8), vector2, @"");
	const juiz::Vector vector3 = juiz::Vector(0.87, 9.9);
	STAssertEquals(juiz::Vector(0.87, 9.9), vector3, @"");
}

- (void)testOperatorAssign {
	juiz::Vector vector1(0.5, 6);
	vector1 = juiz::Vector(1, 40);
	STAssertEquals(juiz::Vector(1, 40), vector1, @"");
	vector1 = juiz::Vector(0.93, 21);
	STAssertEquals(juiz::Vector(0.93, 21), vector1, @"");
}

@end

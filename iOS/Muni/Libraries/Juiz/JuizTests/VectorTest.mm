#import "VectorTest.h"
#import "TestUtility.h"

@implementation VectorTest

- (void)testDefaultConstructor {
	STAssertEquals(juiz::direction::ABOVE, juiz::Vector().direction(), @"");
	STAssertEquals(0.0, juiz::Vector().magnitude(), @"");
}

- (void)testDirection {
	STAssertEquals(juiz::Direction(0.582), juiz::Vector(juiz::Direction(0.582), 55.8).direction(), @"");
	STAssertEquals(juiz::Direction(1.2281), juiz::Vector(juiz::Direction(1.2281), 731).direction(), @"");
}

- (void)testMagnitude {
	STAssertEquals(55.8, juiz::Vector(juiz::Direction(0.582), 55.8).magnitude(), @"");
	STAssertEquals(731.0, juiz::Vector(juiz::Direction(1.2281), 731).magnitude(), @"");
}

- (void)testCopy {
	const juiz::Vector vector1(juiz::Direction(1.06), 30.8);
	const juiz::Vector vector2 = vector1;
	STAssertEquals(juiz::Vector(juiz::Direction(1.06), 30.8), vector2, @"");
	const juiz::Vector vector3 = juiz::Vector(juiz::Direction(0.87), 9.9);
	STAssertEquals(juiz::Vector(juiz::Direction(0.87), 9.9), vector3, @"");
}

- (void)testOperatorAssign {
	juiz::Vector vector1(juiz::Direction(0.5), 6);
	vector1 = juiz::Vector(juiz::Direction(1), 40);
	STAssertEquals(juiz::Vector(juiz::Direction(1), 40), vector1, @"");
	vector1 = juiz::Vector(juiz::Direction(0.93), 21);
	STAssertEquals(juiz::Vector(juiz::Direction(0.93), 21), vector1, @"");
}

- (void)testOperatorEqual {
	STAssertTrue(juiz::Vector(juiz::Direction(0.157), 20.33) == juiz::Vector(juiz::Direction(0.157), 20.33), @"");
	STAssertFalse(juiz::Vector(juiz::Direction(0.158), 0.2034) == juiz::Vector(juiz::Direction(0.2034), 0.158), @"");
	STAssertTrue(juiz::Vector(juiz::Direction(0.54), 66.7) == juiz::Vector(juiz::Direction(0.54), 66.7), @"");
	STAssertFalse(juiz::Vector(juiz::Direction(1), 2) == juiz::Vector(juiz::Direction(2), 1), @"");
	STAssertFalse(juiz::Vector(juiz::Direction(0.305), 30.4) == juiz::Vector(juiz::Direction(0.305), 19.1), @"");
	STAssertFalse(juiz::Vector(juiz::Direction(0.1855), 21.32) == juiz::Vector(juiz::Direction(0.182), 21.32), @"");
}

- (void)testOperatorNotEqual {
	STAssertFalse(juiz::Vector(juiz::Direction(0.157), 20.33) != juiz::Vector(juiz::Direction(0.157), 20.33), @"");
	STAssertTrue(juiz::Vector(juiz::Direction(0.158), 0.2034) != juiz::Vector(juiz::Direction(0.2034), 0.158), @"");
	STAssertFalse(juiz::Vector(juiz::Direction(0.54), 66.7) != juiz::Vector(juiz::Direction(0.54), 66.7), @"");
	STAssertTrue(juiz::Vector(juiz::Direction(1), 2) != juiz::Vector(juiz::Direction(2), 1), @"");
	STAssertTrue(juiz::Vector(juiz::Direction(0.305), 30.4) != juiz::Vector(juiz::Direction(0.305), 19.1), @"");
	STAssertTrue(juiz::Vector(juiz::Direction(0.1855), 21.32) != juiz::Vector(juiz::Direction(0.182), 21.32), @"");
}

- (void)testOperatorUnaryPlus {
	
}

- (void)testOperatorPlus {
}

- (void)testOperatorUnaryMinus {
	
}

- (void)testOperatorMinus {
	
}

- (void)testOperatorMultiplication {
	
}

- (void)testVectorFromXAndY {
	
}

- (void)testX {
	
}

- (void)testY {
	
}

@end

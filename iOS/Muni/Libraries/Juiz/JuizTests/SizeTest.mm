#import "SizeTest.h"
#import "TestUtility.h"

@implementation SizeTest

- (void)testDefaultConstructor {
	STAssertEquals(0.0, juiz::Size().width(), @"");
	STAssertEquals(0.0, juiz::Size().height(), @"");
}

- (void)testWidth {
	STAssertEquals(1.5, juiz::Size(1.5, 2.3).width(), @"");
	STAssertEquals(3.1, juiz::Size(3.1, 1.9).width(), @"");
}

- (void)testHeight {
	STAssertEquals(2.3, juiz::Size(1.5, 2.3).height(), @"");
	STAssertEquals(1.9, juiz::Size(3.1, 1.9).height(), @"");
}

- (void)testCopyConstructor {
	const juiz::Size Size1(10.6, 30.8);
	const juiz::Size Size2 = Size1;
	STAssertEquals(juiz::Size(10.6, 30.8), Size2, @"");
	const juiz::Size Size3 = juiz::Size(8.7, 9.9);
	STAssertEquals(juiz::Size(8.7, 9.9), Size3, @"");
}

- (void)testOperatorAssign {
	juiz::Size Size(5, 6);
	Size = juiz::Size(10, 40);
	STAssertEquals(juiz::Size(10, 40), Size, @"");
	Size = juiz::Size(93, 21);
	STAssertEquals(juiz::Size(93, 21), Size, @"");
}

- (void)testOperatorEqual {
	STAssertTrue(juiz::Size(15.7, 20.33) == juiz::Size(15.7, 20.33), @"");
	STAssertFalse(juiz::Size(15.8, 20.34) == juiz::Size(20.34, 15.8), @"");
	STAssertTrue(juiz::Size(5.4, 66.7) == juiz::Size(5.4, 66.7), @"");
	STAssertFalse(juiz::Size(1, 2) == juiz::Size(2, 1), @"");
	STAssertFalse(juiz::Size(30.5, 30.4) == juiz::Size(30.5, 19.1), @"");
	STAssertFalse(juiz::Size(18.55, 21.32) == juiz::Size(18.2, 21.32), @"");
}

- (void)testOperatorNotEqual {
	STAssertFalse(juiz::Size(15.7, 20.33) != juiz::Size(15.7, 20.33), @"");
	STAssertTrue(juiz::Size(15.8, 20.34) != juiz::Size(20.34, 15.8), @"");
	STAssertFalse(juiz::Size(5.4, 66.7) != juiz::Size(5.4, 66.7), @"");
	STAssertTrue(juiz::Size(1, 2) != juiz::Size(2, 1), @"");
	STAssertTrue(juiz::Size(30.5, 30.4) != juiz::Size(30.5, 19.1), @"");
	STAssertTrue(juiz::Size(18.55, 21.32) != juiz::Size(18.2, 21.32), @"");
}

@end

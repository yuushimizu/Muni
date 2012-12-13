#import "RandomTest.h"

@implementation RandomTest

- (void)testNext {
	juiz::Random random1(765876);
	STAssertEquals(0.1007473443254125466950199552229605615139007568359375, random1.next(), @"");
	STAssertEquals(0.136406071865728062419975685770623385906219482421875, random1.next(), @"");
	STAssertEquals(0.0569692465222686461601142582367174327373504638671875, random1.next(), @"");
	juiz::Random random2(428);
	STAssertEquals(0.6112484498304515678768211728311143815517425537109375, random2.next(), @"");
	STAssertEquals(0.180292382172489329406062097405083477497100830078125, random2.next(), @"");
	STAssertEquals(0.8139331125639304165275689229019917547702789306640625, random2.next(), @"");
	juiz::Random random3(72);
	STAssertEquals(0.257871630009229857449781775358133018016815185546875, random3.next(), @"");
	STAssertEquals(0.0837419989965229039086125339963473379611968994140625, random3.next(), @"");
	STAssertEquals(0.8536169725067723756950499591766856610774993896484375, random3.next(), @"");
}

- (void)testCopy {
	juiz::Random random1(10);
	random1.next();
	juiz::Random random2 = random1;
	STAssertEquals(random1.next(), random2.next(), @"");
	STAssertEquals(random1.next(), random2.next(), @"");
	STAssertEquals(random1.next(), random2.next(), @"");
	random1.next();
	STAssertTrue(random1.next() != random2.next(), @"");
	STAssertTrue(random1.next() != random2.next(), @"");
	STAssertTrue(random1.next() != random2.next(), @"");
}

- (void)testOperatorAssign {
	juiz::Random random1(10);
	juiz::Random random2(20);
	random1.next();
	random2 = random1;
	STAssertEquals(random1.next(), random2.next(), @"");
	STAssertEquals(random1.next(), random2.next(), @"");
	STAssertEquals(random1.next(), random2.next(), @"");
	random1.next();
	STAssertTrue(random1.next() != random2.next(), @"");
	STAssertTrue(random1.next() != random2.next(), @"");
	STAssertTrue(random1.next() != random2.next(), @"");
}

- (void)testNextDoubleWithBound {
	juiz::Random random1(765876);
	STAssertEquals(0.201494688650825093390039910445921123027801513671875, juiz::next_double(random1, 2), @"");
	STAssertEquals(0.0682030359328640312099878428853116929531097412109375, juiz::next_double(random1, 0.5), @"");
	STAssertEquals(0.569692465222686461601142582367174327373504638671875, juiz::next_double(random1, 10), @"");
	juiz::Random random2(72);
	STAssertEquals(0.51574326001845971489956355071626603603363037109375, juiz::next_double(random2, 2), @"");
	STAssertEquals(0.04187099949826145195430626699817366898059844970703125, juiz::next_double(random2, 0.5), @"");
	STAssertEquals(8.5361697250677242010397094418294727802276611328125, juiz::next_double(random2, 10), @"");
}

- (void)testNextDoubleWithMinAndBound {
	juiz::Random random1(42);
	STAssertEquals(8.9259304340671601352141806273721158504486083984375, juiz::next_double(random1, 5, 10), @"");
	STAssertEquals(0.8801437906665874333356214265222661197185516357421875, juiz::next_double(random1, 0.25, 1), @"");
	STAssertEquals(47.1354612486157549255949561484158039093017578125, juiz::next_double(random1, 10, 100), @"");
	juiz::Random random2(961);
	STAssertEquals(8.2601948214263476444330080994404852390289306640625, juiz::next_double(random2, 5, 10), @"");
	STAssertEquals(0.967562974785113993902996298857033252716064453125, juiz::next_double(random2, 0.25, 1), @"");
	STAssertEquals(95.0464560935976550126724760048091411590576171875, juiz::next_double(random2, 10, 100), @"");
}

- (void)testNextIntWithBound {
	juiz::Random random1(1192);
	STAssertEquals(13, juiz::next_int(random1, 100), @"");
	STAssertEquals(1, juiz::next_int(random1, 5), @"");
	STAssertEquals(41, juiz::next_int(random1, 500), @"");
	juiz::Random random2(8823);
	STAssertEquals(15, juiz::next_int(random2, 100), @"");
	STAssertEquals(4, juiz::next_int(random2, 5), @"");
	STAssertEquals(143, juiz::next_int(random2, 500), @"");
}

- (void)testNextIntWithMinAndBound {
	juiz::Random random1(48);
	STAssertEquals(86, juiz::next_int(random1, 50, 150), @"");
	STAssertEquals(3, juiz::next_int(random1, 1, 6), @"");
	STAssertEquals(1188, juiz::next_int(random1, 1000, 1500), @"");
	juiz::Random random2(99);
	STAssertEquals(131, juiz::next_int(random2, 50, 150), @"");
	STAssertEquals(4, juiz::next_int(random2, 1, 6), @"");
	STAssertEquals(1358, juiz::next_int(random2, 1000, 1500), @"");
}

- (void)testNextBool {
	juiz::Random random1(72);
	STAssertTrue(juiz::next_bool(random1), @"");
	STAssertTrue(juiz::next_bool(random1), @"");
	STAssertFalse(juiz::next_bool(random1), @"");
	juiz::Random random2(8823);
	STAssertTrue(juiz::next_bool(random2), @"");
	STAssertFalse(juiz::next_bool(random2), @"");
	STAssertTrue(juiz::next_bool(random2), @"");
}

- (void)testNextRadian {
	juiz::Random random1(42);
	STAssertEquals(4.933469684067990357334565487690269947052001953125, juiz::next_radian(random1), @"");
	STAssertEquals(5.279080275902334307147611980326473712921142578125, juiz::next_radian(random1), @"");
	STAssertEquals(2.592544272140437922047340180142782628536224365234375, juiz::next_radian(random1), @"");
	juiz::Random random2(48);
	STAssertEquals(2.314610924786624224225306534208357334136962890625, juiz::next_radian(random2), @"");
	STAssertEquals(3.208920607083538101278463727794587612152099609375, juiz::next_radian(random2), @"");
	STAssertEquals(2.371495330283173164076515604392625391483306884765625, juiz::next_radian(random2), @"");
}

@end

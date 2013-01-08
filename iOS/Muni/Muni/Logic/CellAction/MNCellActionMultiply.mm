#import "MNCellActionMultiply.h"

@implementation MNCellActionMultiply

- (id)initWithMaxCount:(int)maxCount withIncidence:(double)incidence {
	if (self = [super init]) {
		_restCount = maxCount;
		_incidence = incidence;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	if (_restCount <= 0) return;
	if (MNRandomDouble(0, 1) >= _incidence) return;
	if ([cell multiplyWithEnvironment:environment]) {
		_restCount -= 1;
	}
}

@end

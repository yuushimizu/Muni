#import "MNCellActionMakeMoon.h"
#import "MNUtility.h"

@implementation MNCellActionMakeMoon

- (id)initWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withMaxCount:(int)maxCount withIncidence:(double)incidence {
	if (self = [super init]) {
		_distance = distance;
		_radianIncrease = radianIncrease;
		_restCount = maxCount;
		_incidence = incidence;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	if (_restCount <= 0 || MNRandomDouble(0, 1) >= _incidence) return;
	if ([cell makeMoonWithDistance:_distance withRadianIncrease:_radianIncrease withEnvironment:environment]) {
		_restCount -= 1;
	}
}

@end

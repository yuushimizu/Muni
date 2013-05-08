#import "MNCellMoveRandomWalk.h"
#import "JZUtility.h"
#import "MNUtility.h"

@implementation MNCellMoveRandomWalk

- (void)resetDestinationWithEnvironment:(muni::Environment *)environment {
	_destination = MNRandomPointInSize(environment->field().size());
	_restIntervalFrames = _maxIntervalFrames * MNRandomDouble(0.5, 1.0);
}

- (id)initWithMaxIntervalFrames:(int)maxIntervalFrames withEnvironment:(muni::Environment *)environment {
	if (self = [super init]) {
		_maxIntervalFrames = maxIntervalFrames;
		[self resetDestinationWithEnvironment:environment];
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	if (_restIntervalFrames > 0) {
		_restIntervalFrames -= 1;
		[cell stop];
	} else if (juiz::vector(cell.center, _destination).magnitude() <= cell.radius) {
		[self resetDestinationWithEnvironment:environment];
		[cell stop];
	} else {
		[cell rotateTowards:_destination];
		[cell moveTowards:_destination];
	}
}

@end

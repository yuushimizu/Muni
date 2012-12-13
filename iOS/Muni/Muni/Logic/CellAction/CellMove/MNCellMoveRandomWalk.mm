#import "MNCellMoveRandomWalk.h"
#import "JZUtility.h"
#import "MNUtility.h"

@implementation MNCellMoveRandomWalk

- (void)resetDestinationWithEnvironment:(id<MNEnvironment>)environment {
	_destination = MNRandomPointInSize(environment.field.size());
	_restIntervalFrames = _maxIntervalFrames * MNRandomDouble(0.5, 1.0);
}

- (id)initWithMaxIntervalFrames:(int)maxIntervalFrames withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_maxIntervalFrames = maxIntervalFrames;
		[self resetDestinationWithEnvironment:environment];
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (_restIntervalFrames > 0) {
		_restIntervalFrames -= 1;
		[cell stop];
	} else if (JZDistanceOfPoints(cell.center, _destination) <= cell.radius) {
		[self resetDestinationWithEnvironment:environment];
		[cell stop];
	} else {
		[cell rotateTowards:_destination];
		[cell moveTowards:_destination];
	}
}

@end

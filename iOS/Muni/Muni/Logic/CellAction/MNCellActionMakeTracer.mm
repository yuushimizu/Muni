#import "MNCellActionMakeTracer.h"
#import "MNUtility.h"

@implementation MNCellActionMakeTracer

- (id)initWithIntervalFrames:(int)intervalFrames withIncidence:(double)incidence {
	if (self = [super init]) {
		_intervalFrames = intervalFrames;
		_incidence = incidence;
		_generated = NO;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (_generated || MNRandomDouble(0, 1) >= _incidence) return;
	if ([cell makeTracerWithIntervalFrames:_intervalFrames withEnvironment:environment]) {
		_generated = YES;
	}
}

@end

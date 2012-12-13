#import "MNEffect.h"

@implementation MNEffect

@synthesize center = _center;
@synthesize age = _age;
@synthesize living = _living;

- (id)initWithCenter:(const juiz::Point &)center {
	if (self = [super init]) {
		_center = center;
		_age = 0;
		_living = YES;
	}
	return self;
}

- (void)die {
	_living = NO;
}

- (void)sendFrame {
	if (_living) _age += 1;
}

- (void)draw {
	
}

@end

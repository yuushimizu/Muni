#import "MNField.h"

@implementation MNField

@synthesize size = _size;

- (id)initWithSize:(const juiz::Size &)size {
	if (self = [super init]) {
		_size = size;
	}
	return self;
}

@end

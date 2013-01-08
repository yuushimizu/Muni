#import "MNCellActionConditional.h"

@implementation MNCellActionConditional

- (id)initWithCondition:(BOOL (^)(id<MNCell>))condition withTrueAction:(MNCellAction *)trueAction withFalseAction:(MNCellAction *)falseAction {
	if (self = [super init]) {
		_condition = condition;
		_trueAction = trueAction;
		_falseAction = falseAction;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment {
	[(_condition(cell) ? _trueAction : false) sendFrameWithCell:cell withEnvironment:environment];
}

@end

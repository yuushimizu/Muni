//
//  MNCellActionConditional.h
//  Muni
//
//  Created by Yuu Shimizu on 10/4/12.
//
//

#import "MNCellAction.h"

@interface MNCellActionConditional : MNCellAction {
	BOOL (^_condition)(id<MNCell>);
	MNCellAction *_trueAction;
	MNCellAction *_falseAction;
}

- (id)initWithCondition:(BOOL (^)(id<MNCell>))condition withTrueAction:(MNCellAction *)trueAction withFalseAction:(MNCellAction *)falseAction;

@end

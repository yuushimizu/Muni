//
//  MNCellTargetConditionEnemy.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellTargetConditionEnemy.h"

@implementation MNCellTargetConditionEnemy

- (BOOL)match:(id<MNCell>)me withOther:(id<MNCell>)other {
	return [me hostility:other];
}

@end

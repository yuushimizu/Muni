//
//  MNCellTargetConditionEnemy.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellTargetConditionEnemy.h"

@implementation MNCellTargetConditionEnemy

- (BOOL)match:(id<MNCell>)other {
	return [super match:other] && [self.cell hostility:other];
}

@end

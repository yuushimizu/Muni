//
//  MNCellMoveTailNearestTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveApproachNearestTarget.h"

@implementation MNCellMoveApproachNearestTarget

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	[cell rotateTowards:target.center];
	[cell moveTowards:target.center];
}

@end

//
//  MNCellMoveTailTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveTailTarget.h"

@implementation MNCellMoveTailTarget

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	[cell moveTowards:_target.center];
}

@end

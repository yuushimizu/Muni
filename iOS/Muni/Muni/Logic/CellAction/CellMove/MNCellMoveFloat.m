//
//  MNCellMovePuruPuru.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveFloat.h"

@implementation MNCellMoveFloat

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	[cell moveFor:MNRandomRadian()];
}

@end

//
//  MNCellMoveEscapeTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveEscapeTarget.h"

@implementation MNCellMoveEscapeTarget

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	[cell moveFor:MNRadianFromPoints(target.center, cell.center)];
}

@end

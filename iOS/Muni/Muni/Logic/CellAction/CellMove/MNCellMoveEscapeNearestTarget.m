//
//  MNCellMoveEscapeNearestTarget.m
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveEscapeNearestTarget.h"
#import "JZUtility.h"

@implementation MNCellMoveEscapeNearestTarget

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment {
	double radian = JZRadianFromPoints(target.center, cell.center);
	[cell rotateFor:radian];
	[cell moveFor:radian];
}

@end

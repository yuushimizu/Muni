//
//  MNCellMove.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMove.h"

@implementation MNCellMove

- (CGPoint)pointMovedOfCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	return cell.center;
}

- (void)sendFrameWithCell:(id<MNCell>)cell WithEnvironment:(id<MNEnvironment>)environment {
	[cell moveTo:[self pointMovedOfCell:cell withEnvironment:environment] withEnvironment:environment];
}

@end

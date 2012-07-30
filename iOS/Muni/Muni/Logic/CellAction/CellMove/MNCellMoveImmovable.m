//
//  MNCellMoveImmovable.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveImmovable.h"

@implementation MNCellMoveImmovable

- (CGPoint)pointMovedOfCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	return cell.center;
}

@end

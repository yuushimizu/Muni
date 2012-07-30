//
//  MNCellMovePuruPuru.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMovePuruPuru.h"

@implementation MNCellMovePuruPuru

- (CGPoint)pointMovedOfCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	return MNMovedPoint(cell.center, MNRandomRadian(), cell.speed);
}

@end

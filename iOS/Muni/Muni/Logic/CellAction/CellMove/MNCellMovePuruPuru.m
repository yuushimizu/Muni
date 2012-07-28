//
//  MNCellMovePuruPuru.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMovePuruPuru.h"

@implementation MNCellMovePuruPuru

- (CGPoint)pointMoved {
	return MNMovedPoint(self.cell.center, MNRandomRadian(), self.cell.speed);
}

@end

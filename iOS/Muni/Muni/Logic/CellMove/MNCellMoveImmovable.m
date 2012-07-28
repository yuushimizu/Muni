//
//  MNCellMoveImmovable.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveImmovable.h"

@implementation MNCellMoveImmovable

- (CGPoint)pointMoved {
	return self.cell.center;
}

@end

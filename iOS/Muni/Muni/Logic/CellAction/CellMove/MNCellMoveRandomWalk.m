//
//  MNCellMoveRandomWalk.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveRandomWalk.h"

@implementation MNCellMoveRandomWalk

- (void)resetDestination {
	_destination = MNRandomPointInSize(self.cell.environment.field.size);
}

- (id)initWithCell:(id<MNCell>)cell {
	if (self = [super initWithCell:cell]) {
		[self resetDestination];
	}
	return self;
}

- (CGPoint)pointMoved {
	if (self.cell.center.x == _destination.x && self.cell.center.y == _destination.y) [self resetDestination];
	return MNMovedPointToDestination(self.cell.center, _destination, self.cell.speed);
}

@end

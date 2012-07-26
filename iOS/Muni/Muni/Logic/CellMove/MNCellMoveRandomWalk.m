//
//  MNCellMoveRandomWalk.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveRandomWalk.h"

@implementation MNCellMoveRandomWalk

- (id)initWithCell:(MNBaseCell *)cell {
	if (self = [super initWithCell:cell]) {
		_destination = MNRandomPointInSize(cell.field.size);
	}
	return self;
}

- (CGPoint)movedPoint {
	CGPoint result = MNMovedPointToDestination(self.cell.center, _destination, self.cell.speed);
	if (result.x == _destination.x && result.y == _destination.y) {
		_destination = MNRandomPointInSize(_cell.field.size);
	}
	return result;
}

@end

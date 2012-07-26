//
//  MNCellMoveRandomWalk.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveRandomWalk.h"

@implementation MNCellMoveRandomWalk

- (id)initWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super initWithCell:cell withEnvironment:environment]) {
		_destination = MNRandomPointInSize(environment.field.size);
	}
	return self;
}

- (CGPoint)pointMoved {
	CGPoint result = MNMovedPointToDestination(self.cell.center, _destination, self.cell.speed);
	if (result.x == _destination.x && result.y == _destination.y) {
		_destination = MNRandomPointInSize(self.environment.field.size);
	}
	return result;
}

@end

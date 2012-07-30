//
//  MNCellMoveRandomWalk.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveRandomWalk.h"

@implementation MNCellMoveRandomWalk

- (void)resetDestinationWithEnvironment:(id<MNEnvironment>)environment {
	_destination = MNRandomPointInSize(environment.field.size);
}

- (id)initWithEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		[self resetDestinationWithEnvironment:environment];
	}
	return self;
}

- (CGPoint)pointMovedOfCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	if (cell.center.x == _destination.x && cell.center.y == _destination.y) [self resetDestinationWithEnvironment:environment];
	return MNMovedPointToDestination(cell.center, _destination, cell.speed);
}

@end

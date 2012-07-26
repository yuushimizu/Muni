//
//  MNCellHittingEffect.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellHittingEffect.h"

@implementation MNCellHittingEffect

@synthesize cell = _cell;
@synthesize moveRadian = _moveRadian;
@synthesize moveDistance = _moveDistance;

- (id)initWithCell:(id<MNCell>)cell withMoveRadian:(double)moveRadian withMoveDistance:(double)moveDistance {
	if (self = [super init]) {
		_cell = cell;
		_moveRadian = moveRadian;
		_moveDistance = moveDistance;
	}
	return self;
}

@end

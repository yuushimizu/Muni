//
//  MNCellMove.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMove.h"

@implementation MNCellMove

@synthesize cell = _cell;
@synthesize environment = _environment;

- (id)initWithCell:(id<MNCell>)cell withEnvironment:(id)environment {
	if (self = [super init]) {
		_cell = cell;
		_environment = environment;
	}
	return self;
}

- (CGPoint)pointMoved {
	return _cell.center;
}

@end

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

- (id)initWithCell:(MNBaseCell *)cell {
	if (self = [super init]) {
		_cell = cell;
	}
	return self;
}

- (CGPoint)movedPoint {
	return _cell.center;
}

@end

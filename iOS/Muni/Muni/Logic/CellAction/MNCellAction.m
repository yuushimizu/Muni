//
//  MNCellAction.m
//  Muni
//
//  Created by Yuu Shimizu on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellAction.h"

@implementation MNCellAction

@synthesize cell = _cell;

- (id)initWithCell:(id<MNCell>)cell {
	if (self = [super init]) {
		_cell = cell;
	}
	return self;
}

- (void)sendFrame {
}

@end

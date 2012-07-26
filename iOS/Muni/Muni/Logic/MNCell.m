//
//  MNCell.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCell.h"

@implementation MNCell

- (id)initByRandomWithField:(MNBaseField *)field {
	if (self = [super initByRandomWithField:field]) {
		_eventBits = kMNCellEventBorned;
		_move = [[MNCellMoveRandomWalk alloc] initWithCell:self];
	}
	return self;
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (void)sendFrame {
	_eventBits = 0;
	self.center = [_move movedPoint];
	self.energy -= self.weight * 0.1;
	if (self.energy <= 0) {
		self.energy = 0;
		_eventBits |= kMNCellEventDied;
	}
}

@end

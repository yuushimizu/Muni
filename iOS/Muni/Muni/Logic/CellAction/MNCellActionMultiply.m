//
//  MNCellActionMultiply.m
//  Muni
//
//  Created by Yuu Shimizu on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellActionMultiply.h"

@implementation MNCellActionMultiply

- (id)initWithCell:(id<MNCell>)cell {
	if (self = [super initWithCell:cell]) {
		_restCount = 2;
		_incidence = 0.002;
	}
	return self;
}

- (void)sendFrame {
	if (_restCount <= 0) return;
	if (MNRandomDouble(0, 1) >= _incidence) return;
	[self.cell multiply];
}

@end

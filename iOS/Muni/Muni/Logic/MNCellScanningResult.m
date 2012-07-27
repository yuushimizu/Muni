//
//  MNCellScanningResult.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellScanningResult.h"

@implementation MNCellScanningResult

@synthesize cell = _cell;
@synthesize interval = _interval;

- (id)initWithCell:(id<MNCell>)cell withInterval:(id<MNPointInterval>)interval {
	if (self = [super init]) {
		_cell = cell;
		_interval = interval;
	}
	return self;
}

@end

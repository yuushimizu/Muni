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
@synthesize distance = _distance;

- (id)initWithCell:(id<MNCell>)cell withDistance:(double)distance {
	if (self = [super init]) {
		_cell = cell;
		_distance = distance;
	}
	return self;
}

@end

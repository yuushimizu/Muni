//
//  MNCellTargetCondition.m
//  Muni
//
//  Created by Yuu Shimizu on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellTargetCondition.h"

@implementation MNCellTargetCondition

@synthesize cell = _cell;

- (id)initWithCell:(id<MNCell>)cell {
	if (self = [super init]) {
		_cell = cell;
	}
	return self;
}

- (BOOL)match:(id<MNCell>)other {
	return _cell != other;
}

@end

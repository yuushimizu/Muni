//
//  MNEffect.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNEffect.h"

@implementation MNEffect

@synthesize center = _center;
@synthesize age = _age;
@synthesize living = _living;

- (id)initWithCenter:(CGPoint)center {
	if (self = [super init]) {
		_center = center;
		_age = 0;
		_living = YES;
	}
	return self;
}

- (void)die {
	_living = NO;
}

- (void)sendFrame {
	if (_living) _age += 1;
}

- (void)draw {
	
}

@end

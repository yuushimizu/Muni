//
//  MNCellAttribute.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellAttribute.h"

@implementation MNCellAttribute

@synthesize hue = _hue;

- (id)initWithHue:(double)hue {
	if (self = [super init]) {
		_hue = MIN(MAX(0, hue), 1.0);
	}
	return self;
}

@end

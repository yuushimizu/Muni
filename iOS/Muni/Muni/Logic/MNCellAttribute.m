//
//  MNCellAttribute.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellAttribute.h"

@implementation MNCellAttribute

@synthesize red = _red;
@synthesize green = _green;
@synthesize blue = _blue;

- (id)initWithRed:(double)red withGreen:(double)green withBlue:(double)blue {
	if (self = [super init]) {
		_red = red;
		_green = green;
		_blue = blue;
	}
	return self;
}

@end

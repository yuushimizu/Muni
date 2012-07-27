//
//  MNCellAttribute.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellAttribute.h"

@implementation MNCellAttribute

- (id)initWithRed:(double)red withGreen:(double)green withBlue:(double)blue {
	if (self = [super init]) {
		_red = red;
		_green = green;
		_blue = blue;
		_max = MAX(MAX(_red, _green), _blue);
	}
	return self;
}

- (double)red {
	return _red / _max;
}

- (double)green {
	return _green / _max;
}

- (double)blue {
	return _blue / _max;
}

@end

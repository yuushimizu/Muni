//
//  MNField.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNField.h"

@implementation MNField

@synthesize size = _size;

- (id)initWithSize:(CGSize)size {
	if (self = [super init]) {
		_size = size;
	}
	return self;
}

@end

//
//  MNSpatialIndexPile.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNSpatialIndexPile.h"

@implementation MNSpatialIndexPile

@synthesize object1 = _object1;
@synthesize object2 = _object2;

- (id)initWithObject1:(id)object1 withObject2:(id)object2 {
	if (self = [super init]) {
		_object1 = object1;
		_object2 = object2;
	}
	return self;
}

@end

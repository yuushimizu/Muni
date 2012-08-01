//
//  MNSpatialIndexEntry.m
//  Muni
//
//  Created by Yuu Shimizu on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNSpatialIndexEntry.h"

@implementation MNSpatialIndexEntry

@synthesize object = _object;
@synthesize previousEntry = _previousEntry;
@synthesize nextEntry = _nextEntry;

- (id)initWithObject:(id)object {
	if (self = [super init]) {
		_object = object;
		_previousEntry = nil;
		_nextEntry = nil;
	}
	return self;
}

- (void)insertToNextOf:(MNSpatialIndexEntry *)previousEntry {
	_nextEntry = previousEntry.nextEntry;
	if (_nextEntry) _nextEntry.previousEntry = self;
	_previousEntry = previousEntry;
	_previousEntry.nextEntry = self;
}

- (void)remove {
	if (_previousEntry) _previousEntry.nextEntry = _nextEntry;
	if (_nextEntry) _nextEntry.previousEntry = _previousEntry;
	_previousEntry = nil;
	_nextEntry = nil;
}

@end

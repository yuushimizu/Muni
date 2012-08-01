//
//  MNSpatialIndexEntry.h
//  Muni
//
//  Created by Yuu Shimizu on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNSpatialIndexEntry : NSObject {
	id _object;
	MNSpatialIndexEntry *_previousEntry;
	MNSpatialIndexEntry *_nextEntry;
}

@property (readonly) id object;
@property (nonatomic, retain) MNSpatialIndexEntry *previousEntry;
@property (nonatomic, retain) MNSpatialIndexEntry *nextEntry;

- (id)initWithObject:(id)object;
- (void)insertToNextOf:(MNSpatialIndexEntry *)previousEntry;
- (void)remove;

@end

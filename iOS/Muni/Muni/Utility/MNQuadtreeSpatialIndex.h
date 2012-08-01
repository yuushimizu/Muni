//
//  MNQuadtreeSpatialIndex.h
//  Muni
//
//  Created by Yuu Shimizu on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNSpatialIndexEntry.h"

@interface MNQuadtreeSpatialIndex : NSObject {
	CGSize _areaSize;
	int _maxDepth;
	int _entryCountInMaxDepth;
	CGSize _blockSizeInMaxDepth;
	NSMutableArray *_firstKeysInDepth;
	NSMutableArray *_entries;
	NSMutableDictionary *_objectEntries;
}

- (id)initWithAreaSize:(CGSize)areaSize withMaxDepth:(int)maxDepth;
- (void)removeObject:(id)object;
- (void)addOrUpdateObject:(id)object forRect:(CGRect)rect;
- (void)enumerateObjectsInRect:(CGRect)rect usingBlock:(void (^)(id object))block;
- (void)enumerateCollisionsUsingBlock:(void (^)(id object1, id object2))block;

@end

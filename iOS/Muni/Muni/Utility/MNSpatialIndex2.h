//
//  MNSpatialIndex2.h
//  Muni
//
//  Created by Yuu Shimizu on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNSpatialIndexEntry.h"

@interface MNSpatialIndex2 : NSObject {
	CGSize _blockSize;
	CGSize _blockCount;
	NSMutableArray *_entries;
	NSMutableDictionary *_objectEntries;
	NSArray *_keyCache;
}

@property (readonly) CGSize blockSize;
@property (readonly) CGSize blockCount;

- (id)initWithBlockSize:(CGSize)blockSize withBlockCount:(CGSize)blockCount;
- (id)initWithTotalSize:(CGSize)totalSize withBlockCount:(CGSize)blockCount;
- (void)removeObject:(id)object;
- (void)addOrUpdateObject:(id)object forRect:(CGRect)rect;
- (void)enumerateObjectsInRect:(CGRect)rect usingBlock:(void (^)(id object))block;
- (void)enumerateCollisionsUsingBlock:(void (^)(id object1, id object2))block;

@end

//
//  MNSpatialIndex.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNSpatialIndex : NSObject {
	CGSize _blockSize;
	CGSize _blockCount;
	NSMutableArray *_objects;
	NSMutableDictionary *_objectKeys;
	NSArray *_keyCache;
}

@property (readonly) CGSize blockSize;
@property (readonly) CGSize blockCount;

- (id)initWithBlockSize:(CGSize)blockSize withBlockCount:(CGSize)blockCount;
- (id)initWithTotalSize:(CGSize)totalSize withBlockCount:(CGSize)blockCount;
- (void)removeObject:(id)object;
- (void)addOrUpdateObject:(id)object withRect:(CGRect)rect;
- (NSSet *)objectsForRect:(CGRect)rect;
- (NSArray *)collisions;

@end

//
//  MNSpatialIndex.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNSpatialIndex.h"

@implementation MNSpatialIndex

@synthesize blockSize = _blockSize;
@synthesize blockCount = _blockCount;

- (id)initWithBlockSize:(CGSize)blockSize withBlockCount:(CGSize)blockCount {
	if (self = [super init]) {
		_blockSize = blockSize;
		_blockCount = blockCount;
		_objects = [NSMutableArray array];
		for (int x = 0; x < _blockCount.width; ++x) {
			for (int y = 0; y < _blockCount.height; ++y) {
				[_objects addObject:[NSMutableSet set]];
			}
		}
		_objectKeys = [NSMutableDictionary dictionary];
		NSMutableArray *keyCache = [NSMutableArray arrayWithCapacity:_objects.count];
		for (int i = 0; i < _objects.count; ++i) [keyCache addObject:[NSNumber numberWithInt:i]];
		_keyCache = keyCache;
	}
	return self;
}

- (id)initWithTotalSize:(CGSize)totalSize withBlockCount:(CGSize)blockCount {
	return [self initWithBlockSize:CGSizeMake(totalSize.width / blockCount.width, totalSize.height / blockCount.height) withBlockCount:blockCount];
}

- (NSArray *)keysFromRect:(CGRect)rect {
	int leftKey = rect.origin.x / _blockSize.width;
	if (leftKey < 0) leftKey = 0;
	int rightKey = (rect.origin.x + rect.size.width) / _blockSize.width;
	if (rightKey >= _blockCount.width) rightKey = _blockCount.width - 1;
	int topKey = rect.origin.y / _blockSize.height;
	if (topKey < 0) topKey = 0;
	int bottomKey = (rect.origin.y + rect.size.height) / _blockSize.height;
	if (bottomKey >= _blockCount.height) bottomKey = _blockCount.height - 1;
	NSMutableArray *keys = [NSMutableArray array];
	for (int x = leftKey; x <= rightKey; ++x) {
		for (int y = topKey; y <= bottomKey; ++y) {
			[keys addObject:[_keyCache objectAtIndex:x * _blockCount.height + y]];
		}
	}
	return keys;
}

- (void)removeObject:(id)object {
	NSValue *objectAsKey = [NSValue valueWithNonretainedObject:object];
	NSArray *keys = [_objectKeys objectForKey:objectAsKey];
	if (keys) {
		for (NSNumber *key in keys) [[_objects objectAtIndex:key.intValue] removeObject:object];
		[_objectKeys removeObjectForKey:objectAsKey];
	}
}

- (void)addOrUpdateObject:(id)object withRect:(CGRect)rect {
	NSArray *keys = [self keysFromRect:rect];
	NSValue *objectAsKey = [NSValue valueWithNonretainedObject:object];
	NSArray *oldKeys = [_objectKeys objectForKey:objectAsKey];
	if (oldKeys) {
		if ([keys isEqualToArray:oldKeys]) return;
		for (NSNumber *key in oldKeys) [[_objects objectAtIndex:key.intValue] removeObject:object];
	}
	for (NSNumber *key in keys) [[_objects objectAtIndex:key.intValue] addObject:object];
	[_objectKeys setObject:keys forKey:objectAsKey];
}

- (NSSet *)objectsForKeys:(NSArray *)keys {
	NSMutableSet *objects = [NSMutableSet set];
	for (NSNumber *key in keys) {
		for (id object in [_objects objectAtIndex:[key intValue]]) [objects addObject:object];
	}
	return objects;
}

- (NSSet *)objectsForRect:(CGRect)rect {
	return [self objectsForKeys:[self keysFromRect:rect]];
}

- (NSArray *)collisions {
	NSMutableArray *collisions = [NSMutableArray array];
	NSMutableArray *processedObjects1 = [NSMutableArray array];
	NSMutableArray *processedObjects2 = [NSMutableArray array];
	for (NSArray *objectsInBlock in _objects) {
		for (id object1 in objectsInBlock) {
			for (id object2 in objectsInBlock) {
				if (object1 >= object2) continue;
				int index = 0;
				for (id processedObject1 in processedObjects1) {
					if (processedObject1 == object1 && [processedObjects2 objectAtIndex:index] == object2) goto ignore;
					index += 1;
				}
				[processedObjects1 addObject:object1];
				[processedObjects2 addObject:object2];
				[collisions addObject:object1];
				[collisions addObject:object2];
			ignore:
				;
			}
		}
	}
	return collisions;
}

@end

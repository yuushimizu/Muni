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

- (void)addObject:(id)object forKeys:(NSArray *)keys {
	for (NSNumber *key in keys) [[_objects objectAtIndex:[key intValue]] addObject:object];
	[_objectKeys setObject:keys forKey:[NSValue valueWithNonretainedObject:object]];
}

- (void)addObject:(id)object forKeyPoints:(NSArray *)keyPoints {
	NSMutableArray *keys = [NSMutableArray array];
	for (NSValue *key in keyPoints) {
		CGPoint point = [key CGPointValue];
		[keys addObject:[_keyCache objectAtIndex:point.x * _blockCount.height + point.y]];
	}
	[self addObject:object forKeys:keys];
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

- (void)addObject:(id)object forRect:(CGRect)rect {
	[self addObject:object forKeys:[self keysFromRect:rect]];
}

- (void)removeObject:(id)object {
	NSArray *keys = [_objectKeys objectForKey:[NSValue valueWithNonretainedObject:object]];
	if (keys) {
		for (NSNumber *key in keys) [[_objects objectAtIndex:[key intValue]] removeObject:object];
		[_objectKeys removeObjectForKey:[NSValue valueWithNonretainedObject:object]];
	}
}

- (NSSet *)objectsForKeys:(NSArray *)keys {
	NSMutableSet *objects = [NSMutableSet set];
	for (NSNumber *key in keys) {
		for (id object in [_objects objectAtIndex:[key intValue]]) [objects addObject:object];
	}
	return objects;
}

- (NSSet *)objectsForKeyPoints:(NSArray *)keyPoints {
	NSMutableSet *objects = [NSMutableSet set];
	for (NSValue *key in keyPoints) {
		CGPoint point = [key CGPointValue];
		for (id object in [_objects objectAtIndex:point.x * _blockCount.height + point.y]) {
			[objects addObject:object];
		}
	}
	return objects;
}

- (NSSet *)objectsForRect:(CGRect)rect {
	return [self objectsForKeyPoints:[self keysFromRect:rect]];
}

- (NSSet *)objectsPiledWith:(id)object {
	NSArray *keys = [_objectKeys objectForKey:[NSValue valueWithNonretainedObject:object]];
	return keys ? [self objectsForKeys:keys] : [NSSet set];
}

- (void)enumeratePilesUsingBlock:(void (^)(id object1, id object2))block {
	NSMutableArray *processedObjects1 = [NSMutableArray array];
	NSMutableArray *processedObjects2 = [NSMutableArray array];
	for (NSArray *objectsInBlock in _objects) {
		for (id object1 in objectsInBlock) {
			for (id object2 in objectsInBlock) {
				if (object1 >= object2) continue;
				BOOL proceeded = NO;
				int index = 0;
				for (id processedObject1 in processedObjects1) {
					if (processedObject1 == object1) {
						if ([processedObjects2 objectAtIndex:index] == object2) {
							proceeded = YES;
							break;
						}
					}
					index += 1;
				}
				if (!proceeded) {
					[processedObjects1 addObject:object1];
					[processedObjects2 addObject:object2];
					block(object1, object2);
				}
			}
		}
	}
}

@end

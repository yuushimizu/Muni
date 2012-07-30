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
		_objectKeyPoints = [NSMutableDictionary dictionary];
	}
	return self;
}

- (id)initWithTotalSize:(CGSize)totalSize withBlockCount:(CGSize)blockCount {
	return [self initWithBlockSize:CGSizeMake(totalSize.width / blockCount.width, totalSize.height / blockCount.height) withBlockCount:blockCount];
}

- (void)addObject:(id)object forKeyPoints:(NSArray *)keyPoints {
	for (NSValue *key in keyPoints) {
		CGPoint point = [key CGPointValue];
		[[_objects objectAtIndex:point.x * _blockCount.height + point.y] addObject:object];
	}
	[_objectKeyPoints setObject:keyPoints forKey:[NSValue valueWithNonretainedObject:object]];
}

- (NSArray *)keyPointsFromRect:(CGRect)rect {
	int leftKey = rect.origin.x / _blockSize.width;
	if (leftKey < 0) leftKey = 0;
	int rightKey = (rect.origin.x + rect.size.width) / _blockSize.width;
	if (rightKey >= _blockCount.width) rightKey = _blockCount.width - 1;
	int topKey = rect.origin.y / _blockSize.height;
	if (topKey < 0) topKey = 0;
	int bottomKey = (rect.origin.y + rect.size.height) / _blockSize.height;
	if (bottomKey >= _blockCount.height) bottomKey = _blockCount.height - 1;
	NSMutableArray *keyPoints = [NSMutableArray array];
	for (int x = leftKey; x <= rightKey; ++x) {
		for (int y = topKey; y <= bottomKey; ++y) {
			[keyPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
		}
	}
	return keyPoints;
}

- (void)addObject:(id)object forRect:(CGRect)rect {
	[self addObject:object forKeyPoints:[self keyPointsFromRect:rect]];
}

- (void)removeObject:(id)object {
	NSArray *keyPoints = [_objectKeyPoints objectForKey:[NSValue valueWithNonretainedObject:object]];
	if (keyPoints) {
		for (NSValue *key in keyPoints) {
			CGPoint point = [key CGPointValue];
			[[_objects objectAtIndex:point.x * _blockCount.height + point.y] removeObject:object];
		}
		[_objectKeyPoints removeObjectForKey:[NSValue valueWithNonretainedObject:object]];
	}
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
	return [self objectsForKeyPoints:[self keyPointsFromRect:rect]];
}

- (NSSet *)objectsPiledWith:(id)object {
	NSArray *keyPoints = [_objectKeyPoints objectForKey:[NSValue valueWithNonretainedObject:object]];
	if (keyPoints) {
		return [self objectsForKeyPoints:keyPoints];
	}
	return [NSSet set];
}

- (void)enumeratePilesUsingBlock:(void (^)(id object1, id object2))block {
	NSMutableArray *processedPiles = [NSMutableArray array];
	for (NSArray *objectsInBlock in _objects) {
		for (id object1 in objectsInBlock) {
			for (id object2 in objectsInBlock) {
				if (object1 >= object2) continue;
				BOOL proceeded = NO;
				for (MNSpatialIndexPile *pile in processedPiles) {
					if (pile.object1 == object1 && pile.object2 == object2) {
						proceeded = YES;
						break;
					}
				}
				if (!proceeded) {
					[processedPiles addObject:[[MNSpatialIndexPile alloc] initWithObject1:object1 withObject2:object2]];
					block(object1, object2);
				}
			}
		}
	}
}

@end

//
//  MNQuadtreeSpatialIndex.m
//  Muni
//
//  Created by Yuu Shimizu on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNQuadtreeSpatialIndex.h"

@implementation MNQuadtreeSpatialIndex

- (id)initWithAreaSize:(CGSize)areaSize withMaxDepth:(int)maxDepth {
	if (self = [super init]) {
		_areaSize = areaSize;
		_maxDepth = maxDepth;
		_firstKeysInDepth = [NSMutableArray arrayWithCapacity:maxDepth + 1];
		int nextKey = 0;
		int blockCountInLine = 1;
		for (int depth = 0; depth <= maxDepth; ++depth) {
			[_firstKeysInDepth addObject:[NSNumber numberWithInt:nextKey]];
			nextKey += blockCountInLine * blockCountInLine;
			blockCountInLine *= 2;
		}
		blockCountInLine /= 2;
		_entryCountInMaxDepth = blockCountInLine * blockCountInLine;
		_blockSizeInMaxDepth = CGSizeMake(_areaSize.width / blockCountInLine, _areaSize.height / blockCountInLine);
		_entries = [NSMutableArray arrayWithCapacity:nextKey];
		// add root entries.
		for (int i = 0; i < nextKey; ++i) [_entries addObject:[[MNSpatialIndexEntry alloc] initWithObject:nil]];
		_objectEntries = [NSMutableDictionary dictionary];
	}
	return self;
}

- (int)deepestKeyFromPoint:(CGPoint)point {
	int xKey = point.x / _blockSizeInMaxDepth.width;
	int yKey = point.y / _blockSizeInMaxDepth.height;
	int bitsDestination = 0;
	int key = 0;
	for (int depth = 0; depth <= _maxDepth; ++depth) {
		key = key | ((xKey & 1) << bitsDestination) | ((yKey & 1) << (bitsDestination + 1));
		xKey >>= 1;
		yKey >>= 1;
		bitsDestination += 2;
	}
	return key;
}

- (int)keyFromRect:(CGRect)rect {
	int leftTopKey = [self deepestKeyFromPoint:CGPointMake(MAX(rect.origin.x, 0), MAX(rect.origin.y, 0))];
	int rightBottomKey = [self deepestKeyFromPoint:CGPointMake(MIN(rect.origin.x + rect.size.width, _areaSize.width - 0.1), MIN(rect.origin.y + rect.size.height, _areaSize.height - 0.1))];
	int xor = leftTopKey ^ rightBottomKey;
	int mask = 3;
	int keyDepth = _maxDepth;
	for (int depth = _maxDepth - 1; depth >= 0; --depth) {
		if ((mask & xor) != 0) keyDepth = depth;
		mask <<= 2;
	}
	return [[_firstKeysInDepth objectAtIndex:keyDepth] intValue] + (leftTopKey >> ((_maxDepth - keyDepth) * 2));
}

- (void)removeObject:(id)object {
	NSValue *objectAsKey = [NSValue valueWithNonretainedObject:object];
	MNSpatialIndexEntry *entry = [_objectEntries objectForKey:objectAsKey];
	if (entry){
		[_objectEntries removeObjectForKey:objectAsKey];
		[entry remove];
	}
}

- (void)addOrUpdateObject:(id)object forKey:(int)key {
	NSValue *objectAsKey = [NSValue valueWithNonretainedObject:object];
	MNSpatialIndexEntry *entry = [_objectEntries objectForKey:objectAsKey];
	if (entry) {
		[_objectEntries removeObjectForKey:objectAsKey];
		[entry remove];
	} else {
		entry = [[MNSpatialIndexEntry alloc] initWithObject:object];
	}
	[entry insertToNextOf:[_entries objectAtIndex:key]];
	[_objectEntries setObject:entry forKey:objectAsKey];
}

- (void)addOrUpdateObject:(id)object forRect:(CGRect)rect {
	[self addOrUpdateObject:object forKey:[self keyFromRect:rect]];
}

- (void)enumerateObjectsInRect:(CGRect)rect usingBlock:(void (^)(id))block {
	int key = [self keyFromRect:rect];
	int depth = 0;
	int firstKeyInCurrentDepth;
	for (NSNumber *firstKey in _firstKeysInDepth) {
		firstKeyInCurrentDepth = firstKey.intValue;
		if (firstKey.intValue > key) break;
		depth += 1;
	}
	if (depth > _maxDepth) depth = _maxDepth;
	int keyInCurrentDepth = key - firstKeyInCurrentDepth;
	while (true) {
		for (MNSpatialIndexEntry *entry = [[_entries objectAtIndex:keyInCurrentDepth + firstKeyInCurrentDepth] nextEntry]; entry != nil; entry = entry.nextEntry) {
			block(entry.object);
		}
		if (depth < _maxDepth) {
			depth += 1;
			keyInCurrentDepth <<= 2;
			firstKeyInCurrentDepth = [[_firstKeysInDepth objectAtIndex:depth] intValue];
		} else if ((keyInCurrentDepth & 3) < 3) {
			keyInCurrentDepth += 1;
		} else {
			while (true) {
				depth -= 1;
				if (depth <= 0) return;
				keyInCurrentDepth >>= 2;
				if ((keyInCurrentDepth & 3) < 3) {
					keyInCurrentDepth += 1;
					firstKeyInCurrentDepth = [[_firstKeysInDepth objectAtIndex:depth] intValue];
					break;
				}
			}
		}
	}
}

- (void)enumerateCollisionsUsingBlock:(void (^)(id, id))block {
	NSMutableArray *parentObjectArrays = [NSMutableArray array];
	int depth = 0;
	int firstKeyInCurrentDepth = 0;
	int keyInCurrentDepth = 0;
	while (true) {
		MNSpatialIndexEntry *firstEntry = [[_entries objectAtIndex:keyInCurrentDepth + firstKeyInCurrentDepth] nextEntry];
		for (MNSpatialIndexEntry *entry1 = firstEntry; entry1 != nil; entry1 = entry1.nextEntry) {
			id object1 = entry1.object;
			for (MNSpatialIndexEntry *entry2 = entry1.nextEntry; entry2 != nil; entry2 = entry2.nextEntry) {
				block(object1, entry2.object);
			}
			for (NSArray *parentObjects in parentObjectArrays) {
				for (id object2 in parentObjects) block(object1, object2);
			}
		}
		if (depth < _maxDepth) {
			NSMutableArray *currentObjects = [NSMutableArray array];
			for (MNSpatialIndexEntry *entry = firstEntry; entry != nil; entry = entry.nextEntry) {
				[currentObjects addObject:entry.object];
			}
			[parentObjectArrays addObject:currentObjects];
			depth += 1;
			keyInCurrentDepth <<= 2;
			firstKeyInCurrentDepth = [[_firstKeysInDepth objectAtIndex:depth] intValue];
		} else if ((keyInCurrentDepth & 3) < 3) {
			keyInCurrentDepth += 1;
		} else {
			while (true) {
				depth -= 1;
				if (depth <= 0) return;
				keyInCurrentDepth >>= 2;
				[parentObjectArrays removeLastObject];
				if ((keyInCurrentDepth & 3) < 3) {
					keyInCurrentDepth += 1;
					firstKeyInCurrentDepth = [[_firstKeysInDepth objectAtIndex:depth] intValue];
					break;
				}
			}
		}
	}
}

@end

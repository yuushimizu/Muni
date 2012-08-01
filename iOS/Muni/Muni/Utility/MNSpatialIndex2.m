//
//  MNSpatialIndex2.m
//  Muni
//
//  Created by Yuu Shimizu on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNSpatialIndex2.h"

@implementation MNSpatialIndex2

@synthesize blockSize = _blockSize;
@synthesize blockCount = _blockCount;

- (id)initWithBlockSize:(CGSize)blockSize withBlockCount:(CGSize)blockCount {
	if (self = [super init]) {
		_blockSize = blockSize;
		_blockCount = blockCount;
		_entries = [NSMutableArray array];
		for (int x = 0; x < _blockCount.width; ++x) {
			for (int y = 0; y < _blockCount.height; ++y) {
				// add root entry
				[_entries addObject:[[MNSpatialIndexEntry alloc] initWithObject:nil]];
			}
		}
		_objectEntries = [NSMutableDictionary dictionary];
		NSMutableArray *keyCache = [NSMutableArray arrayWithCapacity:_entries.count];
		for (int i = 0; i < _entries.count; ++i) [keyCache addObject:[NSNumber numberWithInt:i]];
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
	NSArray *entries = [_objectEntries objectForKey:objectAsKey];
	if (entries) {
		[_objectEntries removeObjectForKey:objectAsKey];
		for (MNSpatialIndexEntry *entry in entries) [entry remove];
	}
}

- (void)addOrUpdateObject:(id)object forKeys:(NSArray *)keys {
	NSValue *objectAsKey = [NSValue valueWithNonretainedObject:object];
	int keyCount = keys.count;
	NSMutableArray *entries = [_objectEntries objectForKey:objectAsKey];
	if (entries) {
		for (MNSpatialIndexEntry *entry in entries) [entry remove];
	} else {
		entries = [NSMutableArray arrayWithCapacity:keyCount];
		[_objectEntries setObject:entries forKey:objectAsKey];
	}
	int keyIndex = 0;
	for (MNSpatialIndexEntry *entry in entries) {
		if (keyIndex >= keyCount) {
			[entries removeObjectsInRange:NSMakeRange(keyCount, entries.count - keyCount)];
			break;
		}
		NSNumber *key = [keys objectAtIndex:keyIndex];
		[entry insertToNextOf:[_entries objectAtIndex:key.intValue]];
		keyIndex += 1;
	}
	if (keyIndex < keyCount) {
		for (; keyIndex < keyCount; ++keyIndex) {
			MNSpatialIndexEntry *entry = [[MNSpatialIndexEntry alloc] initWithObject:object];
			NSNumber *key = [keys objectAtIndex:keyIndex];
			[entry insertToNextOf:[_entries objectAtIndex:key.intValue]];
			[entries addObject:entry];
		}
	}
}

- (void)addOrUpdateObject:(id)object forRect:(CGRect)rect {
	[self addOrUpdateObject:object forKeys:[self keysFromRect:rect]];
}

- (void)enumerateObjectsWithKeys:(NSArray *)keys usingBlock:(void (^)(id))block {
	for (NSNumber *key in keys) {
		for (MNSpatialIndexEntry *entry = [[_entries objectAtIndex:key.intValue] nextEntry]; entry != nil; entry = entry.nextEntry) {
			block(entry.object);
		}
	}
}

- (void)enumerateObjectsInRect:(CGRect)rect usingBlock:(void (^)(id))block {
	[self enumerateObjectsWithKeys:[self keysFromRect:rect] usingBlock:block];
}

- (void)enumerateCollisionsUsingBlock:(void (^)(id object1, id object2))block {
	NSMutableArray *processedObjects1 = [NSMutableArray array];
	NSMutableArray *processedObjects2 = [NSMutableArray array];
	for (MNSpatialIndexEntry *rootEntry in _entries) {
		for (MNSpatialIndexEntry *entry1 = rootEntry.nextEntry; entry1 != nil; entry1 = entry1.nextEntry) {
			id object1 = entry1.object;
			for (MNSpatialIndexEntry *entry2 = rootEntry.nextEntry; entry2 != nil; entry2 = entry2.nextEntry) {
				id object2 = entry2.object;
				if (object1 >= object2) continue;
				int index = 0;
				for (id processedObject1 in processedObjects1) {
					if (processedObject1 == object1 && [processedObjects2 objectAtIndex:index] == object2) goto ignore;
					index += 1;
				}
				[processedObjects1 insertObject:object1 atIndex:0];
				[processedObjects2 insertObject:object2 atIndex:0];
				block(object1, object2);
			ignore:
				;
			}
		}
	}
}

@end

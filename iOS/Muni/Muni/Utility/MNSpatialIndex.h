#import <Foundation/Foundation.h>
#import "juiz.h"

@interface MNSpatialIndex : NSObject {
	juiz::Size _blockSize;
	juiz::Size _blockCount;
	NSMutableArray *_objects;
	NSMutableDictionary *_objectKeys;
	NSArray *_keyCache;
}

@property (readonly) juiz::Size blockSize;
@property (readonly) juiz::Size blockCount;

- (id)initWithBlockSize:(const juiz::Size &)blockSize withBlockCount:(const juiz::Size &)blockCount;
- (id)initWithTotalSize:(const juiz::Size &)totalSize withBlockCount:(const juiz::Size &)blockCount;
- (void)removeObject:(id)object;
- (void)addOrUpdateObject:(id)object withRect:(CGRect)rect;
- (NSSet *)objectsForRect:(CGRect)rect;
- (NSArray *)collisions;

@end

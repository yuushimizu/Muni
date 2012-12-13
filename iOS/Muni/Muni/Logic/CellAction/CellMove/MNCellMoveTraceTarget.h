#import "MNCellMoveWithTarget.h"

@interface MNCellMoveTraceTarget : MNCellMoveWithTarget {
	int _intervalFrames;
	NSMutableArray *_positionsOfTarget;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withIntervalFrames:(int)intervalFrames;

@end

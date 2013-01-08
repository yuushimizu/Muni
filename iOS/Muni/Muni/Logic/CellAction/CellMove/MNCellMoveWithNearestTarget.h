#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNCell.h"
#import "CellScanningResult.h"

@interface MNCellMoveWithNearestTarget : MNCellAction {
	BOOL (^_targetCondition)(id<MNCell> me, id<MNCell> other);
	MNCellAction *_moveWithoutTarget;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell> me, id<MNCell> other))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget;

- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment;

@end

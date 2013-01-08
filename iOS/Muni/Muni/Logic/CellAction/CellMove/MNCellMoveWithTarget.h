#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNCell.h"
#import "CellScanningResult.h"

@interface MNCellMoveWithTarget : MNCellAction {
	id<MNCell> _target;
	BOOL (^_targetCondition)(id<MNCell> me, id<MNCell> other);
	MNCellAction *_moveWithoutTarget;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell> me, id<MNCell> other))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget;

- (void)foundNewTarget:(id<MNCell>)target;
- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(muni::Environment *)environment;

@end

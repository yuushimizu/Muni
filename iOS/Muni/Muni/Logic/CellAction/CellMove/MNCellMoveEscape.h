#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNCell.h"

@interface MNCellMoveEscape : MNCellAction {
	BOOL (^_escapeCondition)(id<MNCell> me, id<MNCell> other);
	MNCellAction *_moveWhenNotEscape;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell> me, id<MNCell> other))condition withMoveWhenNotEscape:(MNCellAction *)moveWhenNotEscape;

@end

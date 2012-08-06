//
//  MNCellMoveWithTarget.h
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNCell.h"
#import "MNCellScanningResult.h"

@interface MNCellMoveWithTarget : MNCellAction {
	id<MNCell> _target;
	BOOL (^_targetCondition)(id<MNCell> me, id<MNCell> other);
	MNCellAction *_moveWithoutTarget;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell> me, id<MNCell> other))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withEnvironment:(id<MNEnvironment>)environment;

- (void)foundNewTarget:(id<MNCell>)target;
- (void)sendFrameWithCell:(id<MNCell>)cell withTarget:(id<MNCell>)target withEnvironment:(id<MNEnvironment>)environment;

@end
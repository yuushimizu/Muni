//
//  MNCellMoveTraceTarget.h
//  Muni
//
//  Created by Yuu Shimizu on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveWithTarget.h"

@interface MNCellMoveTraceTarget : MNCellMoveWithTarget {
	int _intervalFrames;
	NSMutableArray *_positionsOfTarget;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withIntervalFrames:(int)intervalFrames withEnvironment:(id<MNEnvironment>)environment;

@end

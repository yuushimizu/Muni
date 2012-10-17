//
//  MNCellMoveMoon.h
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMoveWithTarget.h"

@interface MNCellMoveMoon : MNCellMoveWithTarget {
	double _distance;
	double _radianIncrease;
}

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWithoutTarget:(MNCellAction *)moveWihtoutTarget withDistance:(double)distance withRadianIncrease:(double)radianIncrease;

@end

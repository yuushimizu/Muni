//
//  MNCellMoveTailTarget.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellMove.h"
#import "MNCellTargetConditionEnemy.h"
#import "MNCellScanningResult.h"

@interface MNCellMoveTailTarget : MNCellMove {
	id<MNCell> _target;
	MNCellTargetCondition *_targetCondition;
}

@end

//
//  MNStandardCell.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUtility.h"
#import "MNCell.h"
#import "MNEnvironment.h"
#import "MNCellAttribute.h"
#import "MNCellAction.h"
#import "MNCellActionMultiply.h"
#import "MNCellMoveRandomWalk.h"
#import "MNCellMoveStraight.h"
#import "MNCellMoveFloat.h"
#import "MNCellMoveImmovable.h"
#import "MNCellMoveTailTarget.h"
#import "MNCellMoveTailNearestTarget.h"

@interface MNStandardCell : NSObject<MNCell> {
	int _type;
	double _maxEnergy;
	double _energy;
	double _density;
	MNCellAttribute *_attribute;
	double _speed;
	double _movingSpeed;
	double _movingRadian;
	double _sight;
	CGPoint _center;
	int _eventBits;
	int _previousEventBits;
	NSArray *_actionSources;
	NSArray *_actions;
	double _lastMovedRadian;
	double _lastMovedDistance;
	double _radianForFix;
	double _distanceForFix;
}

@property (readonly) double speed;
@property (readonly) NSArray *actionSources;
@property (readonly) double lastMovedRadian;
@property (readonly) double lastMovedDistance;

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment;
- (id)initByOther:(MNStandardCell *)other withEnvironment:(id<MNEnvironment>)environment;
- (void)realMove:(id<MNEnvironment>)environment;
- (void)moveForFix:(double)radian distance:(double)distance;

@end

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
#import "MNCellActionMakeMoon.h"
#import "MNCellActionMakeTracer.h"
#import "MNCellMoveRandomWalk.h"
#import "MNCellMoveStraight.h"
#import "MNCellMoveFloat.h"
#import "MNCellMoveImmovable.h"
#import "MNCellMoveApproachTarget.h"
#import "MNCellMoveEscapeTarget.h"
#import "MNCellMoveApproachNearestTarget.h"
#import "MNCellMoveEscapeNearestTarget.h"
#import "MNCellMoveTraceTarget.h"
#import "MNCellMoveMoon.h"

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
	int _maxBeat;
	int _beat;
}

@property (readonly) double speed;
@property (readonly) double movingRadian;
@property (readonly) NSArray *actionSources;
@property (readonly) double lastMovedRadian;
@property (readonly) double lastMovedDistance;
@property (readonly) int maxBeat;
@property (readonly) int beat;

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment;
- (id)initByOther:(MNStandardCell *)other withEnvironment:(id<MNEnvironment>)environment;
- (void)realMove:(id<MNEnvironment>)environment;
- (void)moveForFix:(double)radian distance:(double)distance;

@end

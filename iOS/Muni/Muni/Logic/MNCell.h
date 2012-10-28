//
//  MNCell.h
//  Muni
//
//  Created by Yuu Shimizu on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellAttribute.h"
#import "MNEnvironment.h"

#define kMNCellTypeCount 50

#define kMNCellEventDied 2
#define kMNCellEventDamaged 4
#define kMNCellEventCharged 8

@protocol MNCell <NSObject>

@property (readonly) int type;
@property (readonly) long age;
@property (readonly) double maxEnergy;
@property (readonly) double energy;
@property (readonly) double radius;
@property (readonly) double density;
@property (readonly) double weight;
@property (readonly) MNCellAttribute *attribute;
@property (readonly) double sight;
@property (readonly) BOOL living;
@property (readonly) CGPoint center;
@property (readonly) double angle;
@property (readonly) double beatingRadius;

- (void)moveFor:(double)radian withForce:(double)force;
- (void)moveFor:(double)radian;
- (void)accelerate;
- (void)stop;
- (void)moveTowards:(CGPoint)point;
- (void)rotateFor:(double)radian;
- (void)rotateTowards:(CGPoint)point;
- (NSArray *)scanCellsWithCondition:(BOOL (^)(id<MNCell> other))condition withEnvironment:(id<MNEnvironment>)environment;
- (BOOL)hostility:(id<MNCell>)other;
- (void)damage:(double)damage;
- (void)heal:(double)energy;
- (BOOL)multiplyWithEnvironment:(id<MNEnvironment>)environment;
- (BOOL)makeMoonWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(id<MNEnvironment>)environment;
- (BOOL)makeTracerWithIntervalFrames:(int)intervalFrames withEnvironment:(id<MNEnvironment>)environment;
- (BOOL)eventOccurred:(int)event;
- (BOOL)eventOccurredPrevious:(int)event;
- (void)sendFrameWithEnvironment:(id<MNEnvironment>)environment;

@end

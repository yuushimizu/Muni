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

#define kMNCellTypeCount 2

#define kMNCellEventBorned 1
#define kMNCellEventDied 2
#define kMNCellEventDamaged 4
#define kMNCellEventHealed 8

@protocol MNCell <NSObject>

@property (readonly) int type;
@property (readonly) double maxEnergy;
@property (readonly) double energy;
@property (readonly) double radius;
@property (readonly) double density;
@property (readonly) double weight;
@property (readonly) MNCellAttribute *attribute;
@property (readonly) double sight;
@property (readonly) BOOL living;
@property (readonly) CGPoint center;

- (void)moveFor:(double)radian withForce:(double)force;
- (void)moveFor:(double)radian;
- (void)accelerate;
- (void)stop;
- (void)moveTowards:(CGPoint)point;
- (NSArray *)scanCellsWithCondition:(BOOL (^)(id<MNCell> other))condition withEnvironment:(id<MNEnvironment>)environment;
- (BOOL)hostility:(id<MNCell>)other;
- (void)damage:(double)damage;
- (void)heal:(double)energy;
- (void)multiplyWithEnvironment:(id<MNEnvironment>)environment;
- (void)makeMoonWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(id<MNEnvironment>)environment;
- (void)makeTracerWithIntervalFrames:(int)intervalFrames withEnvironment:(id<MNEnvironment>)environment;
- (BOOL)eventOccurred:(int)event;
- (BOOL)eventOccurredPrevious:(int)event;
- (void)sendFrameWithEnvironment:(id<MNEnvironment>)environment;

@end

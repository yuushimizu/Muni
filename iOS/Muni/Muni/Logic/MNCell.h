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

@property (readonly) id<MNEnvironment> environment;
@property (readonly) int type;
@property (readonly) double maxEnergy;
@property (readonly) double energy;
@property (readonly) double radius;
@property (readonly) double density;
@property (readonly) double weight;
@property (readonly) MNCellAttribute *attribute;
@property (readonly) double speed;
@property (readonly) double sight;
@property (readonly) BOOL living;
@property (readonly) CGPoint center;

- (void)moveTo:(CGPoint)center;
- (void)moveFor:(double)radian distance:(double)distance;
- (NSArray *)scanCells:(BOOL (^)(id<MNCell> other))condition;
- (BOOL)hostility:(id<MNCell>)other;
- (void)damage:(double)damage;
- (void)heal:(double)energy;
- (void)multiply;
- (BOOL)eventOccurred:(int)event;
- (BOOL)eventOccurredPrevious:(int)event;
- (void)sendFrame;

@end

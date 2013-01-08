#import <Foundation/Foundation.h>
#import <vector>
#import "juiz.h"
#import "CellFamily.h"
#import "Environment.h"
#import "CellScanningResult.h"

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
@property (readonly) muni::CellFamily family;
@property (readonly) double sight;
@property (readonly) BOOL living;
@property (readonly) juiz::Point center;
@property (readonly) double angle;
@property (readonly) double beatingRadius;

- (void)moveFor:(double)radian withForce:(double)force;
- (void)moveFor:(double)radian;
- (void)accelerate;
- (void)stop;
- (void)moveTowards:(const juiz::Point &)point;
- (void)rotateFor:(double)radian;
- (void)rotateTowards:(const juiz::Point &)point;
- (const std::vector<muni::CellScanningResult>)scanCellsWithCondition:(BOOL (^)(id<MNCell> other))condition withEnvironment:(muni::Environment *)environment;
- (BOOL)hostility:(id<MNCell>)other;
- (void)damage:(double)damage;
- (void)heal:(double)energy;
- (BOOL)multiplyWithEnvironment:(muni::Environment *)environment;
- (BOOL)makeMoonWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(muni::Environment *)environment;
- (BOOL)makeTracerWithIntervalFrames:(int)intervalFrames withEnvironment:(muni::Environment *)environment;
- (BOOL)eventOccurred:(int)event;
- (BOOL)eventOccurredPrevious:(int)event;
- (void)sendFrameWithEnvironment:(muni::Environment *)environment;

@end

#import <Foundation/Foundation.h>
#import "juiz.h"
#import "MNCell.h"
#import "Environment.h"
#import "CellFamily.h"
#import "CellAction.h"
#import <vector>

@interface MNStandardCell : NSObject<MNCell> {
	int _type;
	long _age;
	double _maxEnergy;
	double _energy;
	double _density;
	muni::CellFamily _family;
	double _speed;
	double _movingSpeed;
	double _movingRadian;
	double _sight;
	juiz::Point _center;
	double _angle;
	double _rotationRadian;
	int _eventBits;
	int _previousEventBits;
	NSArray *_actionSources;
	std::vector<std::shared_ptr<muni::CellAction>> _actions;
	double _lastMovedRadian;
	double _lastMovedDistance;
	double _radianForFix;
	double _distanceForFix;
	int _maxBeat;
	int _beat;
}

@property (readonly) double speed;
@property (readonly) double rotationRadian;
@property (readonly) double movingRadian;
@property (readonly) NSArray *actionSources;
@property (readonly) double lastMovedRadian;
@property (readonly) double lastMovedDistance;
@property (readonly) int maxBeat;
@property (readonly) int beat;

- (id)initByRandomWithEnvironment:(muni::Environment *)environment;
- (id)initByOther:(MNStandardCell *)other withEnvironment:(muni::Environment *)environment;
- (void)realMove:(muni::Environment *)environment;
- (void)moveForFix:(double)radian distance:(double)distance;

@end

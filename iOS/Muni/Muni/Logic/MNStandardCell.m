//
//  MNStandardCell.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNStandardCell.h"

@implementation MNStandardCell

@synthesize type = _type;
@synthesize maxEnergy = _maxEnergy;
@synthesize energy = _energy;
@synthesize density = _density;
@synthesize attribute = _attribute;
@synthesize speed = _speed;
@synthesize movingRadian = _movingRadian;
@synthesize sight = _sight;
@synthesize center = _center;
@synthesize actionSources = _actionSources;
@synthesize lastMovedDistance = _lastMovedDistance;
@synthesize lastMovedRadian = _lastMovedRadian;

- (double)randomEnergy {
	// 500 - 8500
	return 500 + MNRandomDouble(0, 10) * MNRandomDouble(0, 10) * MNRandomDouble(0, 10) * MNRandomDouble(3, 8);
}

- (double)randomSpeed {
	// 0.5 - 6.5
	return 0.5 + MNRandomDouble(0, 2) * MNRandomDouble(0, 3);
}

- (MNCellAttribute *)randomAttribute {
	return [[MNCellAttribute alloc] initWithRed:MNRandomDouble(0, 1) withGreen:MNRandomDouble(0, 1) withBlue:MNRandomDouble(0, 1)];
}

- (MNCellAction *(^)(id<MNCell>, id<MNEnvironment>))randomMoveSource {
	int decisionMoveWithoutTarget = MNRandomInt(0, 100);
	MNCellAction *(^sourceWithoutTarget)(id<MNCell>, id<MNEnvironment>);
	if (decisionMoveWithoutTarget < 25) {
		int maxIntervalFrames = MNRandomInt(0, 100);
		sourceWithoutTarget = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveRandomWalk alloc] initWithMaxIntervalFrames:maxIntervalFrames withEnvironment:environment];
		};
	} else if (decisionMoveWithoutTarget < 50) {
		sourceWithoutTarget = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveBound alloc] init];
		};
	} else if (decisionMoveWithoutTarget < 75) {
		sourceWithoutTarget =  ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveFloat alloc] init];
		};
	} else {
		sourceWithoutTarget = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveImmovable alloc] init];
		};
	}
	int decisionMoveWithTarget = MNRandomInt(0, 100);
	decisionMoveWithTarget = 80;
	if (decisionMoveWithTarget < 20) {
		return sourceWithoutTarget;
	} else {
		BOOL (^targetCondition)(id<MNCell> me, id<MNCell> other);
		int decisionTargetCondition = MNRandomInt(0, 100);
		if (decisionTargetCondition < 75) {
			targetCondition = ^(id<MNCell> me, id<MNCell> other) {return (BOOL) (me != other && [me hostility:other]);};
		} else {
			targetCondition = ^(id<MNCell> me, id<MNCell> other) {return (BOOL) (me != other && ![me hostility:other]);};
		}
		if (decisionMoveWithTarget < 60) {
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveTailTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withEnvironment:environment];
			};
		} else {
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveTailNearestTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withEnvironment:environment];
			};
		}
	}
}

- (NSArray *)randomActionSources {
	NSMutableArray *actionSources = [NSMutableArray arrayWithObject:[self randomMoveSource]];
	if (MNRandomInt(0, 100) < 75) {
		[actionSources addObject:^(id<MNCell> cell) {
			return [[MNCellActionMultiply alloc] init];
		}];
	}
	return actionSources;
}

- (void)resetActionsWithEnvironment:(id<MNEnvironment>)environment {
	NSMutableArray *actions = [NSMutableArray array];
	for (MNCellAction *(^actionSource)(id<MNCell>, id<MNEnvironment>environment) in _actionSources) {
		[actions addObject:actionSource(self, environment)];
	}
	_actions = actions;
}

- (void)fixPositionWithEnvironment:(id<MNEnvironment>)environment {
	if (_center.x < 0) {
		_center.x = 0;
		_movingRadian = -_movingRadian;
	} else if (_center.x > environment.field.size.width) {
		_center.x = environment.field.size.width;
		_movingRadian = -_movingRadian;
	}
	if (_center.y < 0) {
		_center.y = 0;
		_movingRadian = -M_PI - _movingRadian;
	} else if (_center.y > environment.field.size.height) {
		_center.y = environment.field.size.height;
		_movingRadian = -M_PI - _movingRadian;
	}
}

- (void)realMove:(id<MNEnvironment>)environment {
	_center = MNMovedPoint(MNMovedPoint(_center, _radianForFix, _distanceForFix), _movingRadian, _movingSpeed);
	_distanceForFix = 0;
	[self fixPositionWithEnvironment:environment];
}

- (void)moveFor:(double)radian withForce:(double)force {
	CGPoint pointMoved = CGPointMake(_center.x + ((sin(_movingRadian) * _movingSpeed) + (sin(radian) * force)), _center.y + ((cos(_movingRadian) * _movingSpeed) + (cos(radian) * force)));
	_movingSpeed = MNDistanceOfPoints(_center, pointMoved);
	_movingRadian = MNRadianFromPoints(_center, pointMoved);

}

- (void)moveFor:(double)radian withTargetSpeed:(double)targetSpeed {
	CGPoint movingPoint = MNMovedPoint(_center, _movingRadian, _movingSpeed);
	CGPoint targetPoint = MNMovedPoint(_center, radian, targetSpeed);
	[self moveFor:MNRadianFromPoints(movingPoint, targetPoint) withForce:MIN(MNDistanceOfPoints(movingPoint, targetPoint), _speed * 0.2 * (1 - _density))];
}

- (void)moveFor:(double)radian {
	[self moveFor:radian withTargetSpeed:_speed];
}

- (void)stop {
	[self moveFor:MNInvertRadian(_movingRadian) withTargetSpeed:0];
}

- (void)moveTowards:(CGPoint)point {
	[self moveFor:MNRadianFromPoints(_center, point)];
}

- (void)moveForFix:(double)radian distance:(double)distance {
	CGPoint pointMoved = CGPointMake(_center.x + ((sin(_radianForFix) * _distanceForFix) + (sin(radian) * distance)), _center.y + ((cos(_radianForFix) * _distanceForFix) + (cos(radian) * distance)));
	_distanceForFix = MNDistanceOfPoints(_center, pointMoved);
	_radianForFix = MNRadianFromPoints(_center, pointMoved);
}

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_type = MNRandomInt(0, kMNCellTypeCount);
		_energy = _maxEnergy = [self randomEnergy];
		_density = MNRandomDouble(0.2, 1.0);
		_attribute = [self randomAttribute];
		_speed = [self randomSpeed];
		_movingSpeed = 0;
		_movingRadian = MNRandomRadian();
		_sight = MNRandomDouble(1, MNDiagonalFromSize(environment.field.size));
		_center = MNRandomPointInSize(environment.field.size);
		[self fixPositionWithEnvironment:environment];
		_eventBits = kMNCellEventBorned;
		_previousEventBits = 0;
		_actionSources = [self randomActionSources];
		[self resetActionsWithEnvironment:environment];
		_distanceForFix = 0;
	}
	return self;
}

- (id)initByOther:(MNStandardCell *)other withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_type = other.type;
		_energy = other.energy * MNRandomDouble(0.9, 1.1);
		_maxEnergy = other.maxEnergy * MNRandomDouble(0.9, 1.1);
		_density = other.density * MNRandomDouble(0.9, 1.1);
		_attribute = [[MNCellAttribute alloc] initWithRed:other.attribute.red * MNRandomDouble(0.9, 1.1) withGreen:other.attribute.green * MNRandomDouble(0.9, 1.1) withBlue:other.attribute.blue * MNRandomDouble(0.9, 1.1)];
		_speed = other.speed * MNRandomDouble(0.9, 1.1);
		_movingSpeed = 0;
		_movingRadian = MNRandomRadian();
		_sight = other.sight * MNRandomDouble(0.9, 1.1);
		_center = other.center;
		_center = MNMovedPoint(other.center, MNRandomRadian(), other.radius);
		[self fixPositionWithEnvironment:environment];
		_eventBits = kMNCellEventBorned;
		_previousEventBits = 0;
		_actionSources = other.actionSources;
		[self resetActionsWithEnvironment:environment];
		_distanceForFix = 0;
	}
	return self;
}

- (double)radius {
	return _maxEnergy * 0.01;
}

- (double)weight {
	return self.radius * _density;
}

- (BOOL)living {
	return _energy > 0;
}

- (NSArray *)scanCellsWithCondition:(BOOL (^)(id<MNCell>))condition withEnvironment:(id<MNEnvironment>)environment {
	return [environment cellsInCircle:_center withRadius:_sight + self.radius withCondition:condition];
}

- (BOOL)hostility:(id<MNCell>)other {
	return fabs(other.attribute.red - _attribute.red) > 0.4 || fabs(other.attribute.green - _attribute.green) > 0.4 || fabs(other.attribute.blue - _attribute.blue) > 0.4;
}

- (void)decreaseEnergy:(double)energy {
	_energy -= energy;
	if (_energy <= 0) {
		_energy = 0;
		_eventBits |= kMNCellEventDied;
	}
}

- (void)damage:(double)damage {
	[self decreaseEnergy:damage];
	_eventBits |= kMNCellEventDamaged;
}

- (void)heal:(double)energy {
	_energy = MIN(_energy + energy, _maxEnergy);
	_eventBits |= kMNCellEventHealed;
}

- (void)multiplyWithEnvironment:(id<MNEnvironment>)environment {
	[self decreaseEnergy:self.maxEnergy * 0.25];
	MNStandardCell *newCell = [[MNStandardCell alloc] initByOther:self withEnvironment:environment];
	[environment addCell:newCell];
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (BOOL)eventOccurredPrevious:(int)event {
	return _previousEventBits & event;
}

- (void)sendFrameWithEnvironment:(id<MNEnvironment>)environment {
	_previousEventBits = _eventBits;
	_eventBits = 0;
	_lastMovedRadian = _movingRadian;
	_lastMovedDistance = _movingSpeed;
	[self decreaseEnergy:self.weight * 0.05];
	if (self.living) for (MNCellAction *action in _actions) {
		[action sendFrameWithCell:self withEnvironment:environment];
	}
}

@end

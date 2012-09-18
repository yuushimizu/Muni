//
//  MNStandardCell.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNStandardCell.h"
#import "JZUtility.h"

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
@synthesize angle = _angle;
@synthesize rotationRadian = _rotationRadian;
@synthesize actionSources = _actionSources;
@synthesize lastMovedDistance = _lastMovedDistance;
@synthesize lastMovedRadian = _lastMovedRadian;
@synthesize maxBeat = _maxBeat;
@synthesize beat = _beat;

- (double)randomEnergy {
	// 700 - 7700
	return 700 + MNRandomDouble(0, 10) * MNRandomDouble(0, 10) * MNRandomDouble(3, 10) * MNRandomDouble(0, 7);
}

- (double)randomSpeed {
	// 0.5 - 4.5
	return 0.5 + MNRandomDouble(0, 2) * MNRandomDouble(0, 2);
}

- (MNCellAttribute *)randomAttribute {
	return [[MNCellAttribute alloc] initWithRed:MNRandomDouble(0, 1) withGreen:MNRandomDouble(0, 1) withBlue:MNRandomDouble(0, 1)];
}

- (MNCellAction *(^)(id<MNCell>, id<MNEnvironment>))randomMoveSource {
	int decisionMoveWithoutTarget = MNRandomInt(0, 3);
	MNCellAction *(^sourceWithoutTarget)(id<MNCell>, id<MNEnvironment>);
	if (decisionMoveWithoutTarget == 0) {
		int maxIntervalFrames = MNRandomInt(0, 100);
		sourceWithoutTarget = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveRandomWalk alloc] initWithMaxIntervalFrames:maxIntervalFrames withEnvironment:environment];
		};
	} else if (decisionMoveWithoutTarget < 1) {
		sourceWithoutTarget =  ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveFloat alloc] init];
		};
	} else {
		sourceWithoutTarget = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveImmovable alloc] init];
		};
	}
	if (MNRandomInt(0, 100) < 10) {
		return sourceWithoutTarget;
	} else {
		BOOL (^targetCondition)(id<MNCell> me, id<MNCell> other);
		int decisionTargetCondition = MNRandomInt(0, 100);
		if (decisionTargetCondition < 75) {
			targetCondition = ^(id<MNCell> me, id<MNCell> other) {return (BOOL) (me != other && [me hostility:other]);};
		} else {
			targetCondition = ^(id<MNCell> me, id<MNCell> other) {return (BOOL) (me != other && ![me hostility:other]);};
		}
		int decisionMoveWithTarget = MNRandomInt(0, 120);
		if (decisionMoveWithTarget < 20) {
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveApproachTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withEnvironment:environment];
			};
		} else if (decisionMoveWithTarget < 40) {
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveEscapeTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withEnvironment:environment];
			};
		} else if (decisionMoveWithTarget < 60) {
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveApproachNearestTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withEnvironment:environment];
			};
		} else if (decisionMoveWithTarget < 80) {
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveEscapeNearestTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withEnvironment:environment];
			};
		} else if (decisionMoveWithTarget < 100) {
			int intervalFrames = MNRandomInt(30, 150);
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveTraceTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withIntervalFrames:intervalFrames withEnvironment:environment];
			};
		} else {
			double distanceRate = MNRandomDouble(1, 4);
			double radianIncrease = MNRandomDouble(3.0 * M_PI / 180.0, 12.0 * M_PI / 180.0) * (MNRandomBool() ? 1 : -1);
			return ^(id<MNCell> cell, id<MNEnvironment> environment) {
				return [[MNCellMoveMoon alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:sourceWithoutTarget(cell, environment) withDistance:distanceRate * cell.radius withRadianIncrease:radianIncrease withEnvironment:environment];
			};
		}
	}
}

- (NSArray *)randomActionSources {
	NSMutableArray *actionSources = [NSMutableArray arrayWithObject:[self randomMoveSource]];
	if (MNRandomInt(0, 100) < 75) {
		int maxCount = MNRandomInt(1, 2) * MNRandomInt(1, 2) * MNRandomInt(1, 2) * MNRandomInt(1, 2) * MNRandomInt(1, 2) * MNRandomInt(1, 2) * MNRandomInt(1, 2);
		double incidence = 0.012;
		[actionSources addObject:^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellActionMultiply alloc] initWithMaxCount:maxCount withIncidence:incidence];
		}];
	}
	if (MNRandomInt(0, 100) < 10) {
		double distanceRate = MNRandomDouble(1, 2);
		double radianIncrease = MNRandomDouble(3.0 * M_PI / 180.0, 12.0 * M_PI / 180.0) * (MNRandomBool() ? 1 : -1);
		int maxCount = MNRandomInt(1, 4) * MNRandomInt(1, 2);
		double incidence = 0.002;
		[actionSources addObject:^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellActionMakeMoon alloc] initWithDistance:distanceRate * cell.radius withRadianIncrease:radianIncrease withMaxCount:maxCount withIncidence:incidence];
		}];
	}
	if (MNRandomInt(0, 100) < 10) {
		int intervalFrames = MNRandomInt(30, 450);
		double incidence = 0.003;
		[actionSources addObject:^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellActionMakeTracer alloc] initWithIntervalFrames:intervalFrames withIncidence:incidence];
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
	double radius = self.radius;
	if (_center.x < radius) {
		_center.x = radius;
		_movingRadian = -_movingRadian;
	} else if (_center.x > environment.field.size.width - radius) {
		_center.x = environment.field.size.width - radius;
		_movingRadian = -_movingRadian;
	}
	if (_center.y < radius) {
		_center.y = radius;
		_movingRadian = -M_PI - _movingRadian;
	} else if (_center.y > environment.field.size.height - radius) {
		_center.y = environment.field.size.height - radius;
		_movingRadian = -M_PI - _movingRadian;
	}
}

- (void)realMove:(id<MNEnvironment>)environment {
	_center = JZMovedPoint(JZMovedPoint(_center, _radianForFix, _distanceForFix), _movingRadian, _movingSpeed);
	_distanceForFix = 0;
	[self fixPositionWithEnvironment:environment];
}

- (void)moveFor:(double)radian withForce:(double)force {
	CGPoint pointMoved = CGPointMake(_center.x + ((sin(_movingRadian) * _movingSpeed) + (sin(radian) * force)), _center.y + ((cos(_movingRadian) * _movingSpeed) + (cos(radian) * force)));
	_movingSpeed = JZDistanceOfPoints(_center, pointMoved);
	_movingRadian = JZRadianFromPoints(_center, pointMoved);

}

- (void)moveFor:(double)radian withTargetSpeed:(double)targetSpeed {
	CGPoint movingPoint = JZMovedPoint(_center, _movingRadian, _movingSpeed);
	CGPoint targetPoint = JZMovedPoint(_center, radian, targetSpeed);
	[self moveFor:JZRadianFromPoints(movingPoint, targetPoint) withForce:MIN(JZDistanceOfPoints(movingPoint, targetPoint), _speed * 0.2 * (1 - _density))];
}

- (void)moveFor:(double)radian {
	[self moveFor:radian withTargetSpeed:_speed];
}

- (void)accelerate {
	[self moveFor:_movingRadian];
}

- (void)stop {
	[self moveFor:JZInvertRadian(_movingRadian) withTargetSpeed:0];
}

- (void)moveTowards:(CGPoint)point {
	[self moveFor:JZRadianFromPoints(_center, point)];
}

- (void)moveForFix:(double)radian distance:(double)distance {
	CGPoint pointMoved = CGPointMake(_center.x + ((sin(_radianForFix) * _distanceForFix) + (sin(radian) * distance)), _center.y + ((cos(_radianForFix) * _distanceForFix) + (cos(radian) * distance)));
	_distanceForFix = JZDistanceOfPoints(_center, pointMoved);
	_radianForFix = JZRadianFromPoints(_center, pointMoved);
}

- (void)rotateFor:(double)radian {
	if (_rotationRadian == 0) {
		while (radian < 0) radian += M_PI * 2;
		while (radian >= M_PI * 2) radian -= M_PI * 2;
		double angleDiff = _angle - radian;
		if (abs(angleDiff) < M_PI) {
			_angle -= MIN(angleDiff * 0.1, M_PI * 0.01);
		} else {
			_angle += MIN(angleDiff * 0.1, M_PI * 0.01);
		}
		while (_angle < 0) _angle += M_PI * 2;
		while (_angle >= M_PI * 2) _angle -= M_PI * 2;
	}
}

- (void)rotateTowards:(CGPoint)point {
	[self rotateFor:JZRadianFromPoints(_center, point)];
}

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_type = MNRandomInt(0, kMNCellTypeCount);
		_maxEnergy = [self randomEnergy];
		_energy = _maxEnergy * MNRandomDouble(0.5, 0.9);
		_density = MNRandomDouble(0.2, 0.9);
		_attribute = [self randomAttribute];
		_speed = [self randomSpeed];
		_movingSpeed = 0;
		_movingRadian = MNRandomRadian();
		_angle = MNRandomRadian();
		_rotationRadian  = MNRandomInt(0, 100) < 30 ? MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) : 0;
		_sight = JZDiagonalFromSize(environment.field.size) * MNRandomDouble(0.1, 0.5);
		_center = MNRandomPointInSize(environment.field.size);
		[self fixPositionWithEnvironment:environment];
		_eventBits = kMNCellEventBoned;
		_previousEventBits = 0;
		_actionSources = [self randomActionSources];
		[self resetActionsWithEnvironment:environment];
		_distanceForFix = 0;
		_maxBeat = MNRandomInt(5, 60) * 2;
		_beat = 0;
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
		_angle = other.angle;
		_rotationRadian = other.rotationRadian;
		_sight = other.sight * MNRandomDouble(0.9, 1.1);
		_center = JZMovedPoint(other.center, MNRandomRadian(), other.radius);
		[self fixPositionWithEnvironment:environment];
		_eventBits = kMNCellEventBoned;
		_previousEventBits = 0;
		_actionSources = other.actionSources;
		[self resetActionsWithEnvironment:environment];
		_distanceForFix = 0;
		_maxBeat = other.maxBeat;
		_beat = other.beat;
	}
	return self;
}

- (id)initAsTracerOf:(MNStandardCell *)parent withIntervalFrames:(int)intervalFrames withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_type = parent.type;
		_energy = parent.energy * 0.9;
		_maxEnergy = parent.maxEnergy * 0.9;
		_density = parent.density;
		_attribute = parent.attribute;
		_speed = parent.speed;
		_movingSpeed = 0;
		_movingRadian = MNRandomRadian();
		_angle = parent.angle;
		_rotationRadian = parent.rotationRadian;
		_sight = parent.sight;
		_center = JZMovedPoint(parent.center, MNRandomRadian(), parent.radius);
		[self fixPositionWithEnvironment:environment];
		_eventBits = kMNCellEventBoned;
		_previousEventBits = 0;
		MNCellAction *(^moveSourceWithoutTarget)(id<MNCell>, id<MNEnvironment>) = [self randomMoveSource];
		MNCellAction *(^moveSoure)(id<MNCell>, id<MNEnvironment>) = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveTraceTarget alloc] initWithCell:cell withCondition:^(id<MNCell> me, id<MNCell> other) {return (BOOL) (other == parent);} withMoveWithoutTarget:moveSourceWithoutTarget(cell, environment) withIntervalFrames:intervalFrames withEnvironment:environment];
		};
		MNCellAction *(^makeTracerSource)(id<MNCell>, id<MNEnvironment>) = ^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellActionMakeTracer alloc] initWithIntervalFrames:intervalFrames withIncidence:0.001];
		};
		_actionSources = [NSArray arrayWithObjects:moveSoure, makeTracerSource, nil];
		[self resetActionsWithEnvironment:environment];
		_distanceForFix = 0;
		_maxBeat = parent.maxBeat;
		_beat = parent.beat;
	}
	return self;
}

- (id)initAsMoonOf:(MNStandardCell *)parent withDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_type = parent.type;
		_maxEnergy = parent.maxEnergy * 0.5;
		_energy = _maxEnergy * 0.5;
		_density = parent.density;
		_attribute = parent.attribute;
		_speed = parent.speed * 2;
		_movingSpeed = 0;
		_movingRadian = MNRandomRadian();
		_angle = parent.angle;
		_rotationRadian = parent.rotationRadian;
		_sight = parent.sight + distance;
		_center = JZMovedPoint(parent.center, MNRandomRadian(), parent.radius + distance + self.radius);
		[self fixPositionWithEnvironment:environment];
		_eventBits = kMNCellEventBoned;
		_previousEventBits = 0;
		_actionSources = [NSArray arrayWithObject:^(id<MNCell> cell, id<MNEnvironment> environment) {
			return [[MNCellMoveMoon alloc] initWithCell:cell withCondition:^(id<MNCell> me, id<MNCell> other) {return (BOOL) (other == parent);} withMoveWithoutTarget:[[MNCellMoveFloat alloc] init] withDistance:distance withRadianIncrease:radianIncrease withEnvironment:environment];
		}];
		[self resetActionsWithEnvironment:environment];
		_distanceForFix = 0;
		_maxBeat = parent.maxBeat;
		_beat = parent.beat;
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

- (BOOL)multiplyWithEnvironment:(id<MNEnvironment>)environment {
	if (self.energy < self.maxEnergy * 0.2) return NO;
	[self decreaseEnergy:self.maxEnergy * 0.15];
	MNStandardCell *newCell = [[MNStandardCell alloc] initByOther:self withEnvironment:environment];
	[environment addCell:newCell];
	return YES;
}

- (BOOL)makeMoonWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(id<MNEnvironment>)environment {
	if (self.maxEnergy < 200) return NO;
	if (self.energy < self.maxEnergy * 0.15) return NO;
	[self decreaseEnergy:self.maxEnergy * 0.1];
	MNStandardCell *moon = [[MNStandardCell alloc] initAsMoonOf:self withDistance:distance withRadianIncrease:radianIncrease withEnvironment:environment];
	[environment addCell:moon];
	return YES;
}

- (BOOL)makeTracerWithIntervalFrames:(int)intervalFrames withEnvironment:(id<MNEnvironment>)environment {
	if (self.maxEnergy < 200) return NO;
	if (self.energy < self.maxEnergy * 0.25) return NO;
	[self decreaseEnergy:self.maxEnergy * 0.2];
	MNStandardCell *newCell = [[MNStandardCell alloc] initAsTracerOf:self withIntervalFrames:intervalFrames withEnvironment:environment];
	[environment addCell:newCell];
	return YES;
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (BOOL)eventOccurredPrevious:(int)event {
	return _previousEventBits & event;
}

- (double)beatingRadius {
	double baseRadius = self.radius;
	return baseRadius + baseRadius * 0.05 * sin(M_PI * _beat / _maxBeat) - baseRadius * 0.025;
}

- (void)sendFrameWithEnvironment:(id<MNEnvironment>)environment {
	_beat += 1;
	if (_beat >= _maxBeat) _beat = 0;
	if (_rotationRadian != 0) {
		_angle += _rotationRadian;
		if (_angle >= M_PI * 2) {
			_angle -= M_PI * 2;
		} else if (_angle < 0) {
			_angle += M_PI * 2;
		}
	}
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

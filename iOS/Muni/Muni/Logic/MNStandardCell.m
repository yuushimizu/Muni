//
//  MNStandardCell.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNStandardCell.h"

@implementation MNStandardCell

@synthesize environment = _environment;
@synthesize type = _type;
@synthesize maxEnergy = _maxEnergy;
@synthesize energy = _energy;
@synthesize density = _density;
@synthesize attribute = _attribute;
@synthesize speed = _speed;
@synthesize sight = _sight;
@synthesize center = _center;
@synthesize actionClasses = _actionClasses;

- (double)randomEnergy {
	// 500 - 8500
	return 500 + MNRandomDouble(0, 20) * MNRandomDouble(0, 20) * MNRandomDouble(0, 20);
}

- (double)randomSpeed {
	// 0.5 - 4.5
	return 0.5 + MNRandomDouble(0, 2) * MNRandomDouble(0, 2);
}

- (MNCellAttribute *)randomAttribute {
	return [[MNCellAttribute alloc] initWithRed:MNRandomDouble(0, 1) withGreen:MNRandomDouble(0, 1) withBlue:MNRandomDouble(0, 1)];
}

- (Class)randomMoveClass {
	int type = MNRandomInt(0, 4);
	if (type == 0) {
		return [MNCellMoveRandomWalk class];
	} else if (type == 1) {
		return [MNCellMovePuruPuru class];
	} else if (type == 2) {
		return [MNCellMoveTailTarget class];
	} else {
		return [MNCellMoveImmovable class];
	}
}

- (NSArray *)randomActionClasses {
	NSMutableArray *actionClasses = [NSMutableArray arrayWithObject:[self randomMoveClass]];
	if (MNRandomBool()) {
		[actionClasses addObject:[MNCellActionMultiply class]];
	}
	return actionClasses;
}

- (void)resetActions {
	NSMutableArray *actions = [NSMutableArray array];
	for (Class actionClass in _actionClasses) [actions addObject:[[actionClass alloc] initWithCell:self]];
	_actions = actions;
}

- (void)fixPosition {
	if (_center.x < 0) {
		_center.x = 0;
	} else if (_center.x >= _environment.field.size.width) {
		_center.x = _environment.field.size.width;
	}
	if (_center.y < 0) {
		_center.y = 0;
	} else if (_center.y >= _environment.field.size.height) {
		_center.y = _environment.field.size.height;
	}
}

- (void)moveTo:(CGPoint)center {
	_center = center;
	[self fixPosition];
}

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_environment = environment;
		_type = MNRandomInt(0, kMNCellTypeCount);
		_energy = _maxEnergy = [self randomEnergy];
		_density = MNRandomDouble(0.2, 1.0);
		_attribute = [self randomAttribute];
		_speed = [self randomSpeed];
		_sight = MNRandomDouble(1, MNDiagonalFromSize(environment.field.size));
		[self moveTo:MNRandomPointInSize(environment.field.size)];
		_eventBits = kMNCellEventBorned;
		_previousEventBits = 0;
		_actionClasses = [self randomActionClasses];
		[self resetActions];
	}
	return self;
}

- (id)initByOther:(MNStandardCell *)other {
	if (self = [super init]) {
		_environment = other.environment;
		_type = other.type;
		_energy = other.energy;
		_maxEnergy = other.maxEnergy;
		_density = other.density;
		_attribute = other.attribute;
		_speed = other.speed;
		_sight = other.sight;
		[self moveTo:other.center];
		_eventBits = kMNCellEventBorned;
		_previousEventBits = 0;
		_actionClasses = other.actionClasses;
		[self resetActions];
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

- (void)moveFor:(double)radian distance:(double)distance {
	_center = MNMovedPoint(_center, radian, distance);
}

- (NSArray *)scanCells:(MNCellTargetCondition *)condition {
	return [_environment cellsInCircle:_center withRadius:_sight + self.radius withCondition:condition];
}

- (BOOL)hostility:(id<MNCell>)other {
	return fabs(other.attribute.red - _attribute.red) > 0.3 || fabs(other.attribute.green - _attribute.green) > 0.3 || fabs(other.attribute.blue - _attribute.blue) > 0.3;
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

- (void)multiply {
	[self decreaseEnergy:self.maxEnergy * 0.25];
	MNStandardCell *newCell = [[MNStandardCell alloc] initByOther:self];
	[newCell moveFor:MNRandomRadian() distance:self.radius * 2];
	[self.environment addCell:newCell];
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (BOOL)eventOccurredPrevious:(int)event {
	return _previousEventBits & event;
}

- (void)sendFrame {
	_previousEventBits = _eventBits;
	_eventBits = 0;
	[self decreaseEnergy:self.weight * 0.1];
	if (self.living) for (MNCellAction *action in _actions) [action sendFrame];
}

@end

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
@synthesize sight = _sight;
@synthesize center = _center;

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

- (MNCellMove *)randomMove:(id<MNEnvironment>)environment {
	int type = MNRandomInt(0, 4);
	if (type == 0) {
		return [[MNCellMoveRandomWalk alloc] initWithCell:self withEnvironment:environment];
	} else if (type == 1) {
		return [[MNCellMovePuruPuru alloc] initWithCell:self withEnvironment:environment];
	} else if (type == 2) {
		return [[MNCellMoveTailTarget alloc] initWithCell:self withEnvironment:environment];
	} else {
		return [[MNCellMoveImmovable alloc] initWithCell:self withEnvironment:environment];
	}
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
		_center = MNRandomPointInSize(environment.field.size);
		_eventBits = kMNCellEventBorned;
		_move = [self randomMove:environment];
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

- (void)moveTo:(CGPoint)center {
	_center = center;
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

- (void)moveFor:(double)radian distance:(double)distance {
	_center = MNMovedPoint(_center, radian, distance);
}

- (BOOL)hostility:(id<MNCell>)other {
	double attributeDiff = fabs(other.attribute.red + other.attribute.green + other.attribute.blue - _attribute.red - _attribute.green - _attribute.blue);
	return attributeDiff > 0.5;
}

- (void)damage:(double)damage {
	_energy -= damage;
	_eventBits |= kMNCellEventDamaged;
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (void)sendFrame {
	_eventBits = 0;
	[self moveTo:[_move pointMoved]];
	_energy -= self.weight * 0.1;
	if (_energy <= 0) {
		_energy = 0;
		_eventBits |= kMNCellEventDied;
	}
}

@end

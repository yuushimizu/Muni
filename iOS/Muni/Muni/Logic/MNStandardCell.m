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
@synthesize color = _color;
@synthesize speed = _speed;
@synthesize sight = _sight;
@synthesize center = _center;

- (double)randomEnergy {
	return 500 + MNRandomDouble(0, 20) * MNRandomDouble(0, 20) * MNRandomDouble(0, 20);
}

- (double)randomSpeed {
	return 0.5 + MNRandomDouble(0, 2) * MNRandomDouble(0, 2);
}

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment {
	if (self = [super init]) {
		_type = MNRandomInt(0, kMNCellTypeCount);
		_energy = _maxEnergy = [self randomEnergy];
		_density = MNRandomDouble(0.2, 1.0);
		_color = MNRandomColor();
		_speed = [self randomSpeed];
		_sight = MNRandomDouble(1, MNDiagonalFromSize(environment.field.size));
		_center = MNRandomPointInSize(environment.field.size);
		_eventBits = kMNCellEventBorned;
		_move = [[MNCellMoveRandomWalk alloc] initWithCell:self withEnvironment:environment];
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
}

- (void)moveFor:(double)radian distance:(double)distance {
	_center = MNMovedPoint(_center, radian, distance);
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (void)sendFrame {
	_eventBits = 0;
	_center = [_move pointMoved];
	_energy -= self.weight * 0.1;
	if (_energy <= 0) {
		_energy = 0;
		_eventBits |= kMNCellEventDied;
	}
}

@end

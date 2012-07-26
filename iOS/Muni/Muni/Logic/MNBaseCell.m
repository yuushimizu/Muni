//
//  MNBaseCell.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNBaseCell.h"

@implementation MNBaseCell

@synthesize field = _field;
@synthesize center = _center;
@synthesize type = _type;
@synthesize maxEnergy = _maxEnergy;
@synthesize energy = _energy;
@synthesize density = _density;
@synthesize color = _color;
@synthesize speed = _speed;
@synthesize sight = _sight;

- (id)initWithField:(MNBaseField *)field withCenter:(CGPoint)center {
	if (self = [super init]) {
		_field = field;
		_center = center;
	}
	return self;
}

- (double)randomEnergy {
	return 500 + MNRandomDouble(0, 20) * MNRandomDouble(0, 20) * MNRandomDouble(0, 20);
}

- (double)randomSpeed {
	return 0.5 + MNRandomDouble(0, 2) * MNRandomDouble(0, 2);
}

- (id)initByRandomWithField:(MNBaseField *)field {
	if (self = [self initWithField:field withCenter:MNRandomPointInSize(field.size)]) {
		_type = MNRandomInt(0, kMNCellTypeCount);
		_energy = _maxEnergy = [self randomEnergy];
		_density = MNRandomDouble(0.2, 1.0);
		_color = MNRandomColor();
		_speed = [self randomSpeed];
		_sight = MNRandomDouble(1, MNDiagonalFromSize(field.size));
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

@end

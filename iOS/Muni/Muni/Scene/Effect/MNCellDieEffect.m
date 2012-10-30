//
//  MNCellDieEffect.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellDieEffect.h"

@implementation MNCellDieEffect

- (id)initWithCell:(id<MNCell>)cell withResources:(MNGLResources *)resources {
	if (self = [super initWithCenter:cell.center]) {
		_initialRadius = cell.radius;
		_sprite = [[JZGLSprite alloc] initWithTexture:[resources cellTexture:cell.type]];
		double saturation = 0.3;
		double brightness = MAX(0, MIN(1.0, 1.3 - cell.density));
		[_sprite setColor:[UIColor colorWithHue:cell.attribute.hue saturation:saturation brightness:brightness alpha:1]];
		_radian = cell.angle;
	}
	return self;
}

- (void)sendFrame {
	[super sendFrame];
	if (self.age > 2) [self die];
}

- (void)draw {
	double radius = _initialRadius + _initialRadius * self.age * 0.5;
	[_sprite drawToRect:CGRectMake(self.center.x - radius, self.center.y - radius, radius * 2, radius * 2) withRotation:_radian];
}

@end

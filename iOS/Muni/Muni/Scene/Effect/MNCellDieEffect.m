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
		_sprite = [[JZGLSprite alloc] initWithTexture:resources.cellEffectDieTexture];
	}
	return self;
}

- (void)sendFrame {
	[super sendFrame];
	if (self.age > 2) [self die];
}

- (void)draw {
	double radius = _initialRadius + _initialRadius * self.age;
	[_sprite drawToRect:CGRectMake(self.center.x - radius, self.center.y - radius, radius * 2, radius * 2)];
}

@end

//
//  MNFieldScene.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNFieldScene.h"

static CGRect rectFromCell(id<MNCell> cell) {
	const double radius = cell.beatingRadius * 1.3 * MIN(cell.age / 5.0, 1);
	return CGRectMake(cell.center.x - radius, cell.center.y - radius, radius * 2, radius * 2);
}

@implementation MNFieldScene

- (id)initWithSize:(CGSize)size withResources:(MNGLResources *)resources {
	if (self = [super init]) {
		_resources = resources;
		_environment = [[MNStandardEnvironment alloc] initWithSize:size withMaxCellCount:kMNMaxCells];
		for (int i = 0; i < kMNMaxCells; ++i) {
			_cellSprites[i] = [[JZGLSprite alloc] init];
		}
		_effects = [NSMutableArray array];
	}
	return self;
}

- (void)sendEffectFrame {
	NSMutableArray *deadEffects = [NSMutableArray array];
	for (MNEffect *effect in _effects) {
		[effect sendFrame];
		if (!effect.living) [deadEffects addObject:effect];
	}
	for (MNEffect *effect in deadEffects) [_effects removeObject:effect];
}

- (void)sendFrame {
	for (id<MNCell> cell in _environment.cells) {
		if ([cell eventOccurred:kMNCellEventDied]) {
			[_effects addObject:[[MNCellDieEffect alloc] initWithCell:cell withResources:_resources]];
		}
	}
	[_environment sendFrame];
	[self sendEffectFrame];
}

- (void)drawEffects {
	for (MNEffect *effect in _effects) [effect draw];
}

- (void)setCellSpriteColor:(JZGLSprite *)sprite withCell:(id<MNCell>)cell {
	if ([cell eventOccurred:kMNCellEventDamaged]) {
		[sprite setColorWithRed:1.0 withGreen:1.0 withBlue:1.0 withAlpha:1.0];
	} else {
		double saturation = MAX(0, (cell.energy / cell.maxEnergy) * 2);
		double brightness = MAX(0, MIN(1.0, 1.3 - cell.density));
		[sprite setColor:[UIColor colorWithHue:cell.attribute.hue saturation:saturation brightness:brightness alpha:1.0]];
	}
}

- (void)draw {
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	int i = 0;
	for (id<MNCell> cell in _environment.cells) {
		JZGLSprite *cellSprite = _cellSprites[i];
		[self setCellSpriteColor:cellSprite withCell:cell];
		[cellSprite setTexture:[_resources cellTexture:cell.type]];
		[cellSprite drawToRect:rectFromCell(cell) withRotation:cell.angle];
		i += 1;
	}
	[self drawEffects];
}

@end

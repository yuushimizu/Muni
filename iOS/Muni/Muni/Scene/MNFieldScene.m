//
//  MNFieldScene.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNFieldScene.h"

static CGRect rectFromCell(id<MNCell> cell) {
	const double radius = cell.radius;
	return CGRectMake(cell.center.x - radius, cell.center.y - radius, radius * 2, radius * 2);
}

@implementation MNFieldScene

- (void)setupBackground:(CGSize)size {
	JZGLTexture *texture = _resources.backgroundTexture;
	_backgroundSprite = [[JZGLSprite alloc] initWithTexture:texture];
	_xBackgroundTileCount = size.width / texture.imageSize.width + 1;
	_yBackgroundTileCount = size.height / texture.imageSize.height + 1;
}

- (id)initWithSize:(CGSize)size {
	if (self = [super init]) {
		_resources = [[MNGLResources alloc] init];
		_environment = [[MNStandardEnvironment alloc] initWithSize:size withMaxCellCount:kMNMaxCells];
		[self setupBackground:size];
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
		if ([cell eventOccurred:kMNCellEventBorned]) {
			[_effects addObject:[[MNCellBornEffect alloc] initWithCell:cell withResources:_resources]];
		} else if ([cell eventOccurred:kMNCellEventDied]) {
			[_effects addObject:[[MNCellDieEffect alloc] initWithCell:cell withResources:_resources]];
		}
	}
	[_environment sendFrame];
	[self sendEffectFrame];
}

- (void)drawBackground {
	const JZGLTexture *texture = _resources.backgroundTexture;
	const double width = texture.imageSize.width;
	const double height = texture.imageSize.height;
	for (int x = 0; x < _xBackgroundTileCount; ++x) {
		for (int y = 0; y < _yBackgroundTileCount; ++y) {
			[_backgroundSprite drawToRect:CGRectMake(x * width, y * height, width, height)];
		}
	}
}

- (void)drawEffects {
	for (MNEffect *effect in _effects) [effect draw];
}

- (void)setCellSpriteColor:(JZGLSprite *)sprite withCell:(id<MNCell>)cell {
	if ([cell eventOccurred:kMNCellEventHealed]) {
		[sprite setColorWithRed:0.0 withGreen:0.7 withBlue:1.0 withAlpha:1.0];
	} else if ([cell eventOccurred:kMNCellEventDamaged]) {
		[sprite setColorWithRed:1.0 withGreen:1.0 withBlue:1.0 withAlpha:1.0];
	} else {
		double red = cell.attribute.red;
		double green = cell.attribute.green;
		double blue = cell.attribute.blue;
		if (cell.density < 0.5) {
			red += (1.0 - red) * (0.5 - cell.density);
			green += (1.0 - green) * (0.5 - cell.density);
			blue += (1.0 - blue) * (0.5 - cell.density);
		} else {
			red *= 1.5 - cell.density;
			green *= 1.5 - cell.density;
			blue *= 1.5 - cell.density;
		}
		[sprite setColorWithRed:red withGreen:green withBlue:blue withAlpha:1.0];
	}
}

- (void)draw {
	[self drawBackground];
	int i = 0;
	for (id<MNCell> cell in _environment.cells) {
		JZGLSprite *cellSprite = _cellSprites[i];
		[self setCellSpriteColor:cellSprite withCell:cell];
		[cellSprite setTexture:[_resources cellTexture:cell.type]];
		[cellSprite drawToRect:rectFromCell(cell)];
		i += 1;
	}
	[self drawEffects];
}

@end

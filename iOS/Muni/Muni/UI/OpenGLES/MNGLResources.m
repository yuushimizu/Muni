//
//  MNGLResources.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNGLResources.h"

@implementation MNGLResources

@synthesize backgroundTexture = _backgroundTexture;
@synthesize cellEffectBornTexture = _cellEffectBornTexture;
@synthesize cellEffectDieTexture = _cellEffectDieTexture;

- (id)init {
	if (self = [super init]) {
		_backgroundTexture = [[JZGLTexture alloc] initWithImageNamed:@"Background1.png"];
		for (int i = 0; i < kMNCellTypeCount; ++i) {
			_cellTextures[i] = [[JZGLTexture alloc] initWithImageNamed:[NSString stringWithFormat:@"Cell%d.png", i + 1]];
		}
		_cellEffectBornTexture = [[JZGLTexture alloc] initWithImageNamed:@"Cell1EffectBorn.png"];
		_cellEffectDieTexture = [[JZGLTexture alloc] initWithImageNamed:@"Cell1EffectDie.png"];
	}
	return self;
}

- (JZGLTexture *)cellTexture:(int)type {
	return _cellTextures[type];
}

@end

//
//  MNSceneDirector.m
//  Muni
//
//  Created by Yuu Shimizu on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNSceneDirector.h"

@implementation MNSceneDirector

- (id)initWithGLView:(JZGLView *)glView withSize:(CGSize)size {
	_size = size;
	_resources = [[MNGLResources alloc] init];
	if (self = [super initWithGLView:glView	withScene:[[MNFieldScene alloc] initWithSize:size withResources:_resources] withTargetFPS:30]) {
	}
	return self;
}

- (void)reset {
	[_resources resetCellTextures];
	[self changeSceneTo:[[MNFieldScene alloc] initWithSize:_size withResources:_resources]];
}

@end

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
	if (self = [super initWithGLView:glView	withScene:[[MNFieldScene alloc] initWithSize:size]]) {
	}
	return self;
}

@end

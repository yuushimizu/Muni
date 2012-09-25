//
//  MNSceneDirector.h
//  Muni
//
//  Created by Yuu Shimizu on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZSceneDirector.h"
#import "MNSceneHandler.h"
#import "MNFieldScene.h"

@interface MNSceneDirector : JZSceneDirector<MNSceneHandler> {
	CGSize _size;
	MNGLResources *_resources;
}

- (id)initWithGLView:(JZGLView *)glView withSize:(CGSize)size;
- (void)reset;

@end

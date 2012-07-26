//
//  JZSceneDirector.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZScene.h"
#import "JZGLView.h"

@interface JZSceneDirector : NSObject {
	id<JZScene> _currentScene;
	id<JZScene> _nextScene;
	JZGLView *_glView;
	id _timer;
	NSDate *_dateLastFPSCalculation;
	int _framesSinceLastFPSCalculation;
	NSDate *_dateLastFrame;
}

- (id)initWithGLView:(JZGLView *)glView withScene:(id<JZScene>)scene;
- (void)changeSceneTo:(id<JZScene>)scene;
- (void)start;
- (void)stop;

@end

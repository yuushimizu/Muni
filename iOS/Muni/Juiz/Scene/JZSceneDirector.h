#import <Foundation/Foundation.h>
#import "JZScene.h"
#import "JZGLView.h"

@interface JZSceneDirector : NSObject {
	int _targetFPS;
	id<JZScene> _currentScene;
	id<JZScene> _nextScene;
	JZGLView *_glView;
	id _timer;
	NSDate *_dateLastFPSCalculation;
	int _framesSinceLastFPSCalculation;
	double _drawingMillisecondsSinceLastFPSCalculation;
	double _sendingFrameMillisecondsSinceLastFPSCalculation;
	NSDate *_dateLastFrame;
}

- (id)initWithGLView:(JZGLView *)glView withScene:(id<JZScene>)scene withTargetFPS:(int)targetFPS;
- (id)initWithGLView:(JZGLView *)glView withScene:(id<JZScene>)scene;
- (void)changeSceneTo:(id<JZScene>)scene;
- (void)start;
- (void)stop;

@end

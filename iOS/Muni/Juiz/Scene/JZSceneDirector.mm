#import "JZSceneDirector.h"

@implementation JZSceneDirector

- (id)initWithGLView:(JZGLView *)glView withScene:(id<JZScene>)scene withTargetFPS:(int)targetFPS {
	if (self = [super init]) {
		_glView = glView;
		_currentScene = scene;
		_targetFPS = targetFPS;
		_nextScene = nil;
		_timer = nil;
	}
	return self;
}

- (id)initWithGLView:(JZGLView *)glView withScene:(id<JZScene>)scene {
	return [self initWithGLView:glView withScene:scene withTargetFPS:60];
}

- (void)changeSceneTo:(id<JZScene>)scene {
	_nextScene = scene;
}

- (void)sendFrame {
	NSDate *dateStartedFrame = [NSDate date];
	NSTimeInterval interval = [dateStartedFrame timeIntervalSinceDate:_dateLastFPSCalculation];
	if (interval >= 1) {
		const double fps = _framesSinceLastFPSCalculation / interval;
		NSLog(@"FPS: %d\tdrawing: %lf\tsending: %lf", (int) round(fps), _drawingMillisecondsSinceLastFPSCalculation / _framesSinceLastFPSCalculation, _sendingFrameMillisecondsSinceLastFPSCalculation / _framesSinceLastFPSCalculation);
		_dateLastFPSCalculation = dateStartedFrame;
		_framesSinceLastFPSCalculation = 0;
		_drawingMillisecondsSinceLastFPSCalculation = 0;
		_sendingFrameMillisecondsSinceLastFPSCalculation = 0;
	}
	_framesSinceLastFPSCalculation++;
	if (_nextScene) {
		_currentScene = _nextScene;
		_nextScene = nil;
	}
	NSDate *dateStartedSendingFrame = [NSDate date];
	[_currentScene sendFrame];
	_sendingFrameMillisecondsSinceLastFPSCalculation += [dateStartedSendingFrame timeIntervalSinceDate:dateStartedFrame];
	NSDate *dateStartedDrawing = [NSDate date];
	[_glView drawWithDrawer:_currentScene];
	_drawingMillisecondsSinceLastFPSCalculation += [dateStartedDrawing timeIntervalSinceDate:dateStartedFrame];
	_dateLastFrame = dateStartedFrame;
}

- (void)start {
	if (_timer != nil) return;
	_dateLastFPSCalculation = [NSDate date];
	_framesSinceLastFPSCalculation = 0;
	_drawingMillisecondsSinceLastFPSCalculation = 0;
	_sendingFrameMillisecondsSinceLastFPSCalculation = 0;
	_dateLastFrame = _dateLastFPSCalculation;
	if ([[[UIDevice currentDevice] systemVersion] compare:@"3.1" options:NSNumericSearch] != NSOrderedAscending) {
		_timer = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(sendFrame)];
		[_timer setFrameInterval:60 / _targetFPS];
		[_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	} else {
		_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / _targetFPS target:self selector:@selector(sendFrame) userInfo:nil repeats:YES];
	}
}

- (void)stop {
	[_timer invalidate];
	_timer = nil;
}

@end
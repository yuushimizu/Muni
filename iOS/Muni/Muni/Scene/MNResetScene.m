//
//  MNResetScene.m
//  Muni
//
//  Created by Yuu Shimizu on 9/23/12.
//
//

#import "MNResetScene.h"

@implementation MNResetScene

- (id)initWithSceneHandler:(id<MNSceneHandler>)sceneHandler {
	if (self = [super init]) {
		_sceneHandler = sceneHandler;
		_restFrame = 15;
	}
	return self;
}

- (void)sendFrame {
	if (_restFrame > 0) {
		_restFrame--;
	} else {
		[_sceneHandler doReset];
	}
}

- (void)draw {
}

@end

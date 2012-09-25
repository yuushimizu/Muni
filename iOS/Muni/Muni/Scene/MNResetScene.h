//
//  MNResetScene.h
//  Muni
//
//  Created by Yuu Shimizu on 9/23/12.
//
//

#import <Foundation/Foundation.h>
#import "JZScene.h"
#import "MNSceneHandler.h"

@interface MNResetScene : NSObject<JZScene> {
	id<MNSceneHandler> _sceneHandler;
	int _restFrame;
}

- (id)initWithSceneHandler:(id<MNSceneHandler>)sceneHandler;

@end

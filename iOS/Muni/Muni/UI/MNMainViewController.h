//
//  MNMainViewController.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMenuView.h"
#import "MNSceneDirector.h"
#import "MNChangeBackgroundViewController.h"

@interface MNMainViewController : UIViewController<MNMenuViewDelegate, MNChangeBackgroundDelegate> {
	MNSceneDirector *_sceneDirector;
	UIImageView *_backgroundImageView;
	MNMenuView *_menuView;
}

- (void)interrupt;
- (void)resume;

@end

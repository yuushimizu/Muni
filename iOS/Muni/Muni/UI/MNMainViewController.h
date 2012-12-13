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

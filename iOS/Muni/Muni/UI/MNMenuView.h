#import <UIKit/UIKit.h>
#import "MNSceneDirector.h"

@protocol MNMenuViewDelegate <NSObject>

- (void)resetButtonPressed;
- (void)changeBackgroundButtonPressed;

@end

@interface MNMenuView : UIView

- (id)initWithFrame:(CGRect)frame withDelegate:(id<MNMenuViewDelegate>)delegate;

@end

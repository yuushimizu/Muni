//
//  MNMenuView.h
//  Muni
//
//  Created by Yuu Shimizu on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNSceneDirector.h"

@protocol MNMenuViewDelegate <NSObject>

- (void)resetButtonPressed;
- (void)changeBackgroundButtonPressed;

@end

@interface MNMenuView : UIView

- (id)initWithFrame:(CGRect)frame withDelegate:(id<MNMenuViewDelegate>)delegate;

@end

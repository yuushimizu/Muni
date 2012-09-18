//
//  MNChangeBackgroundViewController.h
//  Muni
//
//  Created by Yuu Shimizu on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMNBackgroundImageCount 5

@protocol MNChangeBackgroundDelegate <NSObject>

- (void)backgroundChanged:(UIImage *)backgroundImage;

@end

@interface MNChangeBackgroundViewController : UINavigationController

- (id)initWithChangeBackgroundDelegate:(id<MNChangeBackgroundDelegate>)changeBackgroundDelegate;

@end

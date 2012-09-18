//
//  MNMenuView.m
//  Muni
//
//  Created by Yuu Shimizu on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNMenuView.h"

@implementation MNMenuView

- (id)initWithFrame:(CGRect)frame withDelegate:(id<MNMenuViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
		double width = 64;
		double height = 64;
		double gap = 10;
		double left = gap;
		double top = frame.size.height - height - gap;
		UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
		resetButton.frame = CGRectMake(left, top, width, height);
		[resetButton setImage:[UIImage imageNamed:@"ButtonReset"] forState:UIControlStateNormal];
		[resetButton addTarget:delegate action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:resetButton];
		UIButton *changeBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
		left += width + gap;
		changeBackgroundButton.frame = CGRectMake(left, top, width, height);
		[changeBackgroundButton setImage:[UIImage imageNamed:@"ButtonChangeBackground"] forState:UIControlStateNormal];
		[changeBackgroundButton addTarget:delegate action:@selector(changeBackgroundButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:changeBackgroundButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

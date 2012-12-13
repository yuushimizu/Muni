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
		double width = MIN(64, frame.size.width * 0.2);
		double height = width;
		double gap = floor(width / 6);
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
		[changeBackgroundButton setImage:[UIImage imageNamed:@"ButtonSettings"] forState:UIControlStateNormal];
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

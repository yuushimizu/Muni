//
//  JZScene.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZGLDrawer.h"

@protocol JZScene <JZGLDrawer>

- (void)sendFrame;
- (void)draw;

@end

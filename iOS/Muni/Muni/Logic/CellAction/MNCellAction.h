//
//  MNCellAction.h
//  Muni
//
//  Created by Yuu Shimizu on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNEnvironment.h"

@protocol MNCell;

@interface MNCellAction : NSObject

- (void)sendFrameWithCell:(id<MNCell>)cell WithEnvironment:(id<MNEnvironment>)environment;

@end

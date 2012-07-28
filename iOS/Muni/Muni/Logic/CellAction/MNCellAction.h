//
//  MNCellAction.h
//  Muni
//
//  Created by Yuu Shimizu on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MNCell;

@interface MNCellAction : NSObject {
	id<MNCell> _cell;
}

@property id<MNCell> cell;

- (id)initWithCell:(id<MNCell>)cell;
- (void)sendFrame;

@end

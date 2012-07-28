//
//  MNCellMove.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MNCell;

@interface MNCellMove : NSObject {
	id<MNCell> _cell;
}

@property (readonly) id<MNCell> cell;

- (id)initWithCell:(id<MNCell>)cell;
- (CGPoint)pointMoved;

@end

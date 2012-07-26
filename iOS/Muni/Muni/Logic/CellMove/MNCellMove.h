//
//  MNCellMove.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCell.h"
#import "MNEnvironment.h"

@interface MNCellMove : NSObject {
	id<MNCell> _cell;
	id<MNEnvironment> _environment;
}

@property (readonly) id<MNCell> cell;
@property (readonly) id<MNEnvironment> environment;

- (id)initWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment;
- (CGPoint)pointMoved;

@end

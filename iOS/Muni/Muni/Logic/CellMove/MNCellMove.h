//
//  MNCellMove.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNBaseCell.h"

@interface MNCellMove : NSObject {
	MNBaseCell *_cell;
}

@property (readonly) MNBaseCell *cell;

- (id)initWithCell:(MNBaseCell *)cell;
- (CGPoint)movedPoint;

@end

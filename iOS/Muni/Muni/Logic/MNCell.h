//
//  MNCell.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUtility.h"
#import "MNBaseCell.h"
#import "MNBaseField.h"
#import "MNCellMove.h"
#import "MNCellMoveRandomWalk.h"

#define kMNCellEventBorned 1
#define kMNCellEventDied 2

@interface MNCell : MNBaseCell {
	int _eventBits;
	MNCellMove *_move;
}

- (id)initByRandomWithField:(MNBaseField *)field;
- (BOOL)eventOccurred:(int)event;
- (void)sendFrame;

@end

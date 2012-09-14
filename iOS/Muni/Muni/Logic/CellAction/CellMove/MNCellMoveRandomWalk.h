//
//  MNCellMoveRandomWalk.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNCell.h"

@interface MNCellMoveRandomWalk : MNCellAction {
	CGPoint _destination;
	int _maxIntervalFrames;
	int _restIntervalFrames;
}

- (id)initWithMaxIntervalFrames:(int)maxIntervalFrames withEnvironment:(id<MNEnvironment>)environment;

@end

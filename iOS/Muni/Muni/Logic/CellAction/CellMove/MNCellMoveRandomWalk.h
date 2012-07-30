//
//  MNCellMoveRandomWalk.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellMove.h"
#import "MNUtility.h"

@interface MNCellMoveRandomWalk : MNCellMove {
	CGPoint _destination;
}

- (id)initWithEnvironment:(id<MNEnvironment>)environment;

@end
//
//  MNStandardCell.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUtility.h"
#import "MNCell.h"
#import "MNCellMove.h"
#import "MNCellMoveRandomWalk.h"
#import "MNCellMoveImmovable.h"

@interface MNStandardCell : NSObject<MNCell> {
	int _type;
	double _maxEnergy;
	double _energy;
	double _density;
	UIColor *_color;
	double _speed;
	double _sight;
	CGPoint _center;
	int _eventBits;
	MNCellMove *_move;
}

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment;

@end

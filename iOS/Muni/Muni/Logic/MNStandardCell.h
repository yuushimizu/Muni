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
#import "MNEnvironment.h"
#import "MNCellAttribute.h"
#import "MNCellAction.h"
#import "MNCellActionMultiply.h"
#import "MNCellMove.h"
#import "MNCellMoveRandomWalk.h"
#import "MNCellMovePuruPuru.h"
#import "MNCellMoveImmovable.h"
#import "MNCellMoveTailTarget.h"

@interface MNStandardCell : NSObject<MNCell> {
	int _type;
	double _maxEnergy;
	double _energy;
	double _density;
	MNCellAttribute *_attribute;
	double _speed;
	double _sight;
	CGPoint _center;
	int _eventBits;
	int _previousEventBits;
	NSArray *_actionSources;
	NSArray *_actions;
}

@property (readonly) NSArray *actionSources;

- (id)initByRandomWithEnvironment:(id<MNEnvironment>)environment;
- (id)initByOther:(MNStandardCell *)other withEnvironment:(id<MNEnvironment>)environment;

@end

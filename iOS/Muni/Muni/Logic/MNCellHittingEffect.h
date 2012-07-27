//
//  MNCellHittingEffect.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCell.h"

@interface MNCellHittingEffect : NSObject {
	id<MNCell> _cell;
	double _moveRadian;
	double _moveDistance;
	double _damage;
}

@property (readonly) id<MNCell> cell;
@property (readonly) double moveRadian;
@property (readonly) double moveDistance;
@property (readonly) double damage;

- (id)initWithCell:(id<MNCell>)cell withMoveRadian:(double)moveRadian withMoveDistance:(double)moveDistance withDamage:(double)damage;

@end

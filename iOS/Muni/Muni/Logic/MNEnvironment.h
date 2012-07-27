//
//  MNEnvironment.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNField.h"
#import "MNCell.h"
#import "MNCellTargetCondition.h"

@protocol MNEnvironment <NSObject>

@property (readonly) MNField *field;
@property (readonly) NSArray *cells;

- (void)sendFrame;
- (void)addCell:(id<MNCell>)cell;
- (NSArray *)scanCellsBy:(id<MNCell>)cell withCondition:(id<MNCellTargetCondition>)condition;

@end

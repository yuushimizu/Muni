//
//  MNEnvironment.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNField.h"

@protocol MNCell;

@protocol MNEnvironment <NSObject>

@property (readonly) MNField *field;
@property (readonly) NSArray *cells;

- (void)sendFrame;
- (void)addCell:(id<MNCell>)cell;
- (NSArray *)cellsInCircle:(CGPoint)center withRadius:(double)radius withCondition:(BOOL (^)(id<MNCell> other))condition;

@end

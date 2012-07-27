//
//  MNCellTargetCondition.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCell.h"

@protocol MNCellTargetCondition <NSObject>

- (BOOL)match:(id<MNCell>)me withOther:(id<MNCell>)other;

@end

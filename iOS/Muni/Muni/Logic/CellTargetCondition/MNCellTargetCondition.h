//
//  MNCellTargetCondition.h
//  Muni
//
//  Created by Yuu Shimizu on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCell.h"

@interface MNCellTargetCondition : NSObject {
	id<MNCell> _cell;
}

@property (readonly) id<MNCell> cell;

- (id)initWithCell:(id<MNCell>)cell;
- (BOOL)match:(id<MNCell>)other;

@end

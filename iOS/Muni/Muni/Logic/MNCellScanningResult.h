//
//  MNCellScanningResult.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCell.h"
#import "MNPointInterval.h"

@interface MNCellScanningResult : NSObject {
	id<MNCell> _cell;
	id<MNPointInterval> _interval;
}

@property (readonly) id<MNCell> cell;
@property (readonly) id<MNPointInterval> interval;

- (id)initWithCell:(id<MNCell>)cell withInterval:(id<MNPointInterval>)interval;

@end

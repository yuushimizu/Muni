//
//  MNCellScanningResult.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCell.h"

@interface MNCellScanningResult : NSObject {
	id<MNCell> _cell;
	double _distance;
}

@property (readonly) id<MNCell> cell;
@property (readonly) double distance;

- (id)initWithCell:(id<MNCell>)cell withDistance:(double)distance;

@end

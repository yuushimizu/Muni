//
//  MNPointIntervalByRadianAndDistance.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNPointInterval.h"

@interface MNPointIntervalByRadianAndDistance : NSObject<MNPointInterval> {
	double _radian;
	double _distance;
}

- (id)initWithRadian:(double)radian withDistance:(double)distance;

@end

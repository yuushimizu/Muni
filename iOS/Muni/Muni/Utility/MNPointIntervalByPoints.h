//
//  MNPointIntervalByPoints.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNPointInterval.h"

@interface MNPointIntervalByPoints : NSObject<MNPointInterval> {
	CGPoint _source;
	CGPoint _destination;
}

- (id)initWithSource:(CGPoint)source withDestination:(CGPoint)destination;

@end

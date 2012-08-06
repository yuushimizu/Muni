//
//  MNCellActionMakeTracer.h
//  Muni
//
//  Created by Yuu Shimizu on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellAction.h"
#import "MNCell.h"

@interface MNCellActionMakeTracer : MNCellAction {
	BOOL _generated;
	int _intervalFrames;
	double _incidence;
}

- (id)initWithIntervalFrames:(int)intervalFrames withIncidence:(double)incidence;

@end

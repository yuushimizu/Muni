//
//  MNCellActionMakeMoon.h
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellAction.h"
#import "MNCell.h"

@interface MNCellActionMakeMoon : MNCellAction {
	int _restCount;
	double _incidence;
	double _distance;
	double _radianIncrease;
}

- (id)initWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withMaxCount:(int)maxCount withIncidence:(double)incidence;

@end

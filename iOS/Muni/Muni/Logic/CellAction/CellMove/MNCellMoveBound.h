//
//  MNCellMoveBound.h
//  Muni
//
//  Created by Yuu Shimizu on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNCell.h"
#import "MNUtility.h"

@interface MNCellMoveBound : MNCellAction {
	double _radian;
	BOOL _moved;
}

@end

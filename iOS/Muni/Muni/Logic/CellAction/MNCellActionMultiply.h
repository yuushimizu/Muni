//
//  MNCellActionMultiply.h
//  Muni
//
//  Created by Yuu Shimizu on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNUtility.h"
#import "MNCell.h"

@interface MNCellActionMultiply : MNCellAction {
	int _restCount;
	double _incidence;
}

- (id)initWithMaxCount:(int)maxCount withIncidence:(double)incidence;

@end

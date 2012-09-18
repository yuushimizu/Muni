//
//  MNStandardCellSource.h
//  Muni
//
//  Created by Yuu Shimizu on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCellAttribute.h"

@interface MNStandardCellSource : NSObject {
	int _type;
	double _maxEnergy;
	double _density;
	MNCellAttribute *_attribute;
	double _speed;
	double _sight;
	double _rotationRadian;
	NSArray *_actionSources;
	int _maxBeat;
}

@end

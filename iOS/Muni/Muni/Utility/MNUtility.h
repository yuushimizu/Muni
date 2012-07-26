//
//  MNUtility.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNPointInterval.h"
#import "MNPointIntervalByPoints.h"
#import "MNPointIntervalByRadianAndDistance.h"

double MNRandomDouble(double min, double limit);
int MNRandomInt(int min, int limit);
CGPoint MNRandomPointInSize(CGSize size);
UIColor *MNRandomColor(void);
CGPoint MNMovedPoint(CGPoint start, double radian, double distance);
CGPoint MNMovedPointToDestination(CGPoint start, CGPoint destination, double distance);
double MNDiagonalFromSize(CGSize size);
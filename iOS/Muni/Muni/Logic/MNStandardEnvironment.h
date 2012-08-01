//
//  MNStandardEnvironment.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNEnvironment.h"
#import "MNStandardCell.h"
#import "MNSpatialIndex.h"
#import "MNPointIntervalByPoints.h"
#import "MNCellScanningResult.h"

@interface MNStandardEnvironment : NSObject<MNEnvironment> {
	MNField *_field;
	NSMutableArray *_cells;
	int _maxCellCount;
	NSMutableArray *_addedCellsQueue;
	double _incidence;
	MNSpatialIndex *_spatialIndex;
}

- (id)initWithSize:(CGSize)size withMaxCellCount:(int)maxCellCount;

@end
#import <Foundation/Foundation.h>
#import "juiz.h"
#import "Field.h"
#import "MNEnvironment.h"
#import "MNStandardCell.h"
#import "MNSpatialIndex.h"
#import "MNCellScanningResult.h"

@interface MNStandardEnvironment : NSObject<MNEnvironment> {
	muni::Field _field;
	NSMutableArray *_cells;
	int _maxCellCount;
	NSMutableArray *_addedCellsQueue;
	double _incidence;
	MNSpatialIndex *_spatialIndex;
}

- (id)initWithSize:(const juiz::Size &)size withMaxCellCount:(int)maxCellCount;

@end
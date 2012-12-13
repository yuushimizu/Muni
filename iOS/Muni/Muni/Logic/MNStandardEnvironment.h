#import <Foundation/Foundation.h>
#import "juiz.h"
#import "MNEnvironment.h"
#import "MNStandardCell.h"
#import "MNSpatialIndex.h"
#import "MNCellScanningResult.h"

@interface MNStandardEnvironment : NSObject<MNEnvironment> {
	MNField *_field;
	NSMutableArray *_cells;
	int _maxCellCount;
	NSMutableArray *_addedCellsQueue;
	double _incidence;
	MNSpatialIndex *_spatialIndex;
}

- (id)initWithSize:(const juiz::Size &)size withMaxCellCount:(int)maxCellCount;

@end
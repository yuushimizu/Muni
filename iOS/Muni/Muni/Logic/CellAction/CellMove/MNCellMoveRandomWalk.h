#import <Foundation/Foundation.h>
#import "juiz.h"
#import "MNCellAction.h"
#import "MNCell.h"

@interface MNCellMoveRandomWalk : MNCellAction {
	juiz::Point _destination;
	int _maxIntervalFrames;
	int _restIntervalFrames;
}

- (id)initWithMaxIntervalFrames:(int)maxIntervalFrames withEnvironment:(muni::Environment *)environment;

@end

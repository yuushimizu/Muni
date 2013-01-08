#import <Foundation/Foundation.h>
#include "Environment.h"

@protocol MNCell;

@interface MNCellAction : NSObject

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(muni::Environment *)environment;

@end

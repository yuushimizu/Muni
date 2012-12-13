#import <Foundation/Foundation.h>
#import "juiz.h"
#import "MNField.h"

@protocol MNCell;

@protocol MNEnvironment <NSObject>

@property (readonly) MNField *field;
@property (readonly) NSArray *cells;

- (void)sendFrame;
- (void)addCell:(id<MNCell>)cell;
- (NSArray *)cellsInCircle:(const juiz::Point &)center withRadius:(double)radius withCondition:(BOOL (^)(id<MNCell> other))condition;

@end

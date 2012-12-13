#import <Foundation/Foundation.h>
#import "juiz.h"
#import "Field.h"

@protocol MNCell;

@protocol MNEnvironment <NSObject>

@property (readonly) muni::Field field;
@property (readonly) NSArray *cells;

- (void)sendFrame;
- (void)addCell:(id<MNCell>)cell;
- (NSArray *)cellsInCircle:(const juiz::Point &)center withRadius:(double)radius withCondition:(BOOL (^)(id<MNCell> other))condition;

@end

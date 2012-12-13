#import <Foundation/Foundation.h>
#import "juiz.h"

@interface MNEffect : NSObject {
	juiz::Point _center;
	double _age;
	BOOL _living;
}

@property (readonly) juiz::Point center;
@property (readonly) double age;
@property (readonly) BOOL living;

- (id)initWithCenter:(const juiz::Point &)center;
- (void)die;
- (void)sendFrame;
- (void)draw;

@end

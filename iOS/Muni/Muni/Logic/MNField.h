#import <Foundation/Foundation.h>
#import "juiz.h"
#import "MNUtility.h"

@interface MNField : NSObject {
	juiz::Size _size;
}

@property (readonly) juiz::Size size;

- (id)initWithSize:(const juiz::Size &)size;

@end

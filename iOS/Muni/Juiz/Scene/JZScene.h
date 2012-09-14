#import <Foundation/Foundation.h>
#import "JZGLDrawer.h"

@protocol JZScene <JZGLDrawer>

- (void)sendFrame;
- (void)draw;

@end

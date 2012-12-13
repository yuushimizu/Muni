#import <Foundation/Foundation.h>
#import "JZSceneDirector.h"
#import "MNSceneHandler.h"
#import "MNFieldScene.h"

@interface MNSceneDirector : JZSceneDirector<MNSceneHandler> {
	juiz::Size _size;
	MNGLResources *_resources;
}

- (id)initWithGLView:(JZGLView *)glView withSize:(const juiz::Size &)size;
- (void)reset;

@end

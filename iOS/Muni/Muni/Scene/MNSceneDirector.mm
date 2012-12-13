#import "MNSceneDirector.h"
#import "MNResetScene.h"

@implementation MNSceneDirector

- (id)initWithGLView:(JZGLView *)glView withSize:(const juiz::Size &)size {
	_size = size;
	_resources = [[MNGLResources alloc] init];
	if (self = [super initWithGLView:glView	withScene:[[MNFieldScene alloc] initWithSize:size withResources:_resources] withTargetFPS:30]) {
	}
	return self;
}

- (void)reset {
	[self changeSceneTo:[[MNResetScene alloc] initWithSceneHandler:self]];
}

- (void)doReset {
	[_resources resetCellTextures];
	[self changeSceneTo:[[MNFieldScene alloc] initWithSize:_size withResources:_resources]];
}

@end

#import <Foundation/Foundation.h>
#import "juiz.h"
#import "JZScene.h"
#import "MNStandardEnvironment.h"
#import "MNStandardCell.h"
#import "MNField.h"
#import "MNGLResources.h"
#import "JZGLSprite.h"
#import "MNEffect.h"
#import "MNCellDieEffect.h"

#define kMNMaxCells 100

@interface MNFieldScene : NSObject<JZScene> {
	MNStandardEnvironment *_environment;
	MNGLResources *_resources;
	JZGLSprite *_cellSprites[kMNMaxCells];
	NSMutableArray *_effects;
}

- (id)initWithSize:(const juiz::Size &)size withResources:(MNGLResources *)resources;

@end

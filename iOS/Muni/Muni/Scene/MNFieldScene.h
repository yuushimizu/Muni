#import <Foundation/Foundation.h>
#import <memory>
#import "juiz.h"
#import "JZScene.h"
#import "StandardEnvironment.h"
#import "MNStandardCell.h"
#import "Field.h"
#import "MNGLResources.h"
#import "JZGLSprite.h"
#import "MNEffect.h"
#import "MNCellDieEffect.h"

#define kMNMaxCells 100

@interface MNFieldScene : NSObject<JZScene> {
	std::shared_ptr<muni::StandardEnvironment> _environment;
	MNGLResources *_resources;
	JZGLSprite *_cellSprites[kMNMaxCells];
	NSMutableArray *_effects;
}

- (id)initWithSize:(const juiz::Size &)size withResources:(MNGLResources *)resources;

@end

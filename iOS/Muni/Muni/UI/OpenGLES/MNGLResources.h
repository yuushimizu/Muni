#import <Foundation/Foundation.h>
#import "JZGLTexture.h"
#import "MNCell.h"

@interface MNGLResources : NSObject {
	JZGLTexture *_backgroundTexture;
	JZGLTexture *_cellTextures[kMNCellTypeCount];
	JZGLTexture *_cellEffectBornTexture;
	JZGLTexture *_cellEffectDieTexture;
}

@property (readonly) JZGLTexture *backgroundTexture;
@property (readonly) JZGLTexture *cellEffectBornTexture;
@property (readonly) JZGLTexture *cellEffectDieTexture;

- (JZGLTexture *)cellTexture:(int)type;
- (void)resetCellTextures;

@end

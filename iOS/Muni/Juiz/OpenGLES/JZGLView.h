#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "JZGLDrawer.h"

@interface JZGLView : UIView {
	CAEAGLLayer *_glLayer;
	EAGLContext *_context;
	GLuint _frameBuffer;
	GLuint _colorRenderBuffer;
}

@property (readonly) CAEAGLLayer *glLayer;
@property (readonly) EAGLContext *context;

- (void)drawWithDrawer:(id<JZGLDrawer>)drawer;

@end

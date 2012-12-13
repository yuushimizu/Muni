#import "JZGLView.h"

@implementation JZGLView

@synthesize glLayer = _glLayer;
@synthesize context = _context;

- (void)initializeLayer:(CGRect)frame {
	_glLayer = [CAEAGLLayer layer];
	const double scale = [UIScreen mainScreen].scale;
	_glLayer.contentsScale = scale;
	const double width = frame.size.width;
	const double height = frame.size.height;
	_glLayer.frame = CGRectMake(0, 0, width, height);
	_glLayer.opaque = NO;
	_glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
								   [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
								   kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
								   nil];
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:_context];
	glGenFramebuffersOES(1, &_frameBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _frameBuffer);
	glGenRenderbuffersOES(1, &_colorRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderBuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:_glLayer];
	glEnable(GL_TEXTURE_2D);
	glViewport(0, 0, width * scale, height * scale);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0.0f, (float) width, (float) height, 0.0f, -1.0f, 1.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_FOG);
	glDisable(GL_STENCIL_TEST);
	[self.layer addSublayer:_glLayer];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.contentScaleFactor = [UIScreen mainScreen].scale;
		self.multipleTouchEnabled = YES;
		self.backgroundColor = [UIColor blackColor];
		[self initializeLayer:frame];
    }
    return self;
}

- (void)dealloc {
	glDeleteRenderbuffersOES(1, &_colorRenderBuffer);
	glDeleteFramebuffersOES(1, &_frameBuffer);
	[EAGLContext setCurrentContext:nil];
}

- (void)drawWithDrawer:(id<JZGLDrawer>)drawer {
	[EAGLContext setCurrentContext:_context];
	glClear(GL_COLOR_BUFFER_BIT);
	[drawer draw];
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

@end

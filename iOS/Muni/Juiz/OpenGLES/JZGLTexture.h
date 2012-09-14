#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface JZGLTexture : NSObject {
	GLuint _texture;
	CGSize _imageSize;
	CGSize _textureSize;
	CGSize _ratio;
	GLfloat _triangleStripVertices[2 * 4];
}

@property (readonly) GLuint texture;
@property (readonly) CGSize imageSize;
@property (readonly) CGSize textureSize;
@property (readonly) CGSize ratio;
@property (readonly) const GLfloat *triangleStripVertices;

- (id)initWithCGImage:(const CGImageRef)cgImage;
- (id)initWithImageNamed:(NSString *)name;
- (void)bind;
- (void)copyTriangleVertices:(GLfloat *)destination;
- (void)copyTriangleStripVertices:(GLfloat *)destination;

@end

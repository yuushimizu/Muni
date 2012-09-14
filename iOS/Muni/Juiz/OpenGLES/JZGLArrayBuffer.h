#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface JZGLArrayBuffer : NSObject {
	GLuint _buffer;
}

- (id)initWithSize:(GLsizeiptr)size withData:(const GLvoid *)data withUsage:(GLenum)usage;
- (void)bind;
- (void)unbind;
- (void)setSize:(GLsizeiptr)size withData:(const GLvoid *)data withUsage:(GLenum)usage;

@end

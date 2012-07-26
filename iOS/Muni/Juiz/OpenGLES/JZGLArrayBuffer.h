//
//  JZGLArrayBuffer.h
//  Muni
//
//  Created by Yuu Shimizu on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

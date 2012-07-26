//
//  JZGLArrayBuffer.m
//  Muni
//
//  Created by Yuu Shimizu on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JZGLArrayBuffer.h"

@implementation JZGLArrayBuffer

- (id)initWithSize:(GLsizeiptr)size withData:(const GLvoid *)data withUsage:(GLenum)usage {
	self = [super init];
	if (self) {
		glGenBuffers(1, &_buffer);
		glBindBuffer(GL_ARRAY_BUFFER, _buffer);
		glBufferData(GL_ARRAY_BUFFER, size, data, usage);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}
	return self;
}

- (void)dealloc {
	glDeleteBuffers(1, &_buffer);
}

- (void)bind {
	glBindBuffer(GL_ARRAY_BUFFER, _buffer);
}

- (void)unbind {
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)setSize:(GLsizeiptr)size withData:(const GLvoid *)data withUsage:(GLenum)usage {
	[self bind];
	glBufferData(GL_ARRAY_BUFFER, size, data, usage);
	[self unbind];
}

@end

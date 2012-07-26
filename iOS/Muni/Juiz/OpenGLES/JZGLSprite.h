//
//  JZGLSprite.h
//  Muni
//
//  Created by Yuu Shimizu on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "JZGLTexture.h"
#import "JZGLArrayBuffer.h"

@interface JZGLSprite : NSObject {
	GLfloat _vertices[2 * 4];
	JZGLArrayBuffer *_verticesBuffer;
	BOOL _textured;
	JZGLTexture *_texture;
	JZGLArrayBuffer *_textureVerticesBuffer;
	BOOL _colored;
	JZGLArrayBuffer *_colorBuffer;
}

- (void)setTexture:(JZGLTexture *)texture;
- (void)setColorWithRed:(GLfloat)red withGreen:(GLfloat)green withBlue:(GLfloat)blue withAlpha:(GLfloat)alpha;
- (void)setColor:(UIColor *)color;
- (id)initWithTexture:(JZGLTexture *)texture;
- (void)drawToRect:(CGRect)rect;

@end

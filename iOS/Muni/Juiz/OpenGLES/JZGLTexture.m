#import "JZGLTexture.h"

static int toPow2(int n) {
	int result = 1;
	for (int current = n; current > 0; current /= 2, result *= 2);
	return n * 2 == result ? n : result;
}

@implementation JZGLTexture

@synthesize texture = _texture;
@synthesize imageSize = _imageSize;
@synthesize textureSize = _textureSize;
@synthesize ratio = _ratio;

- (id)initWithCGImage:(CGImageRef)cgImage {
	if (self = [super init]) {
		_imageSize = CGSizeMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
		_textureSize =  CGSizeMake(toPow2(_imageSize.width), toPow2(_imageSize.height));
		_ratio = CGSizeMake(_imageSize.width / _textureSize.width, _imageSize.height / _textureSize.height);
		const NSMutableData *imageData = [[NSMutableData alloc] initWithLength: (int) _textureSize.width * (int) _textureSize.height * 4]; // RGBA
		const CGContextRef context = CGBitmapContextCreate([imageData mutableBytes], (int) _textureSize.width, (int) _textureSize.height, 8 /* bits */, (int) _textureSize.width * 4 /* bytes per row */, CGImageGetColorSpace(cgImage), kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(context, CGRectMake(0.0, _textureSize.height - _imageSize.height, _imageSize.width, _imageSize.height), cgImage);
		CGContextRelease(context);
		glGenTextures(1, &_texture);
		glBindTexture(GL_TEXTURE_2D, _texture);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int) _textureSize.width, (int) _textureSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, [imageData bytes]);
		_triangleStripVertices[0] = 0.0f; _triangleStripVertices[1] = 0.0f;
		_triangleStripVertices[2] = 0.0f; _triangleStripVertices[3] = _ratio.height;
		_triangleStripVertices[4] = _ratio.width; _triangleStripVertices[5] = 0.0f;
		_triangleStripVertices[6] = _ratio.width; _triangleStripVertices[7] = _ratio.height;
	}
	return self;
}

- (id)initWithImageNamed:(NSString *)name {
	return [self initWithCGImage:[UIImage imageNamed:name].CGImage];
}

- (void)dealloc {
	glDeleteTextures(1, &_texture);
}

- (const GLfloat *)triangleStripVertices {
	return _triangleStripVertices;
}

- (void)bind {
	glBindTexture(GL_TEXTURE_2D, _texture);
}

- (void)copyTriangleVertices:(GLfloat *)destination {
	destination[0] = 0.0f; destination[1] = 0.0f;
	destination[2] = 0.0f; destination[3] = _ratio.height;
	destination[4] = _ratio.width; destination[5] = 0.0f;
	destination[6] = _ratio.width; destination[7] = 0.0f;
	destination[8] = 0.0f; destination[9] = _ratio.height;
	destination[10] = _ratio.width; destination[11] = _ratio.height;
}

- (void)copyTriangleStripVertices:(GLfloat *)destination {
	memcpy(destination, _triangleStripVertices, sizeof(_triangleStripVertices));
}

@end

#import "JZGLSprite.h"
#import "JZUtility.h"

static void setTriangleStripVerticesFromRect(GLfloat *vertices, CGRect rect) {
	const double left = rect.origin.x;
	const double right = left + rect.size.width;
	const double top = rect.origin.y;
	const double bottom = top + rect.size.height;
	vertices[0] = left; vertices[1] = top;
	vertices[2] = left; vertices[3] = bottom;
	vertices[4] = right; vertices[5] = top;
	vertices[6] = right; vertices[7] = bottom;
}

static void setTriangleStripVerticesFromRectWithRotation(GLfloat *vertices, CGRect rect, double radian) {
	const double left = rect.origin.x;
	const double right = left + rect.size.width;
	const double top = rect.origin.y;
	const double bottom = top + rect.size.height;
	const juiz::Point center(left + rect.size.width / 2, top + rect.size.height / 2);
	const juiz::Point leftTop = JZRotatedPoint(juiz::Point(left, top), center, radian);
	const juiz::Point leftBottom = JZRotatedPoint(juiz::Point(left, bottom), center, radian);
	const juiz::Point rightTop = JZRotatedPoint(juiz::Point(right, top), center, radian);
	const juiz::Point rightBottom = JZRotatedPoint(juiz::Point(right, bottom), center, radian);
	vertices[0] = leftTop.x(); vertices[1] = leftTop.y();
	vertices[2] = leftBottom.x(); vertices[3] = leftBottom.y();
	vertices[4] = rightTop.x(); vertices[5] = rightTop.y();
	vertices[6] = rightBottom.x(); vertices[7] = rightBottom.y();
}

@implementation JZGLSprite

- (id)init {
	if (self = [super init]) {
		_verticesBuffer = [[JZGLArrayBuffer alloc] initWithSize:sizeof(_vertices) withData:_vertices withUsage:GL_DYNAMIC_DRAW];
		_textured = NO;
		_colored = NO;
	}
	return self;
}

- (id)initWithTexture:(JZGLTexture *)texture {
	if (self = [self init]) {
		[self setTexture:texture];
	}
	return self;
}

- (void)setTexture:(JZGLTexture *)texture {
	_texture = texture;
	GLfloat textureVertices[2 * 4];
	[_texture copyTriangleStripVertices:textureVertices];
	if (_textured) {
		[_textureVerticesBuffer setSize:sizeof(textureVertices) withData:textureVertices withUsage:GL_DYNAMIC_DRAW];
	} else {
		_textureVerticesBuffer = [[JZGLArrayBuffer alloc] initWithSize:sizeof(textureVertices) withData:textureVertices withUsage:GL_DYNAMIC_DRAW];
		_textured = YES;
	}
}

- (void)setColorWithRed:(GLfloat)red withGreen:(GLfloat)green withBlue:(GLfloat)blue withAlpha:(GLfloat)alpha {
	GLfloat colors[4 * 4] = {
		red, green, blue, alpha,
		red, green, blue, alpha,
		red, green, blue, alpha,
		red, green, blue, alpha
	};
	if (_colored) {
		[_colorBuffer setSize:sizeof(colors) withData:colors withUsage:GL_DYNAMIC_DRAW];
	} else {
		_colorBuffer = [[JZGLArrayBuffer alloc] initWithSize:sizeof(colors) withData:colors withUsage:GL_DYNAMIC_DRAW];
		_colored = YES;
	}
}

- (void)setColor:(UIColor *)color {
	CGFloat red, green, blue, alpha;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	[self setColorWithRed:red withGreen:green withBlue:blue withAlpha:alpha];
}

- (void)drawToRect:(CGRect)rect {
	setTriangleStripVerticesFromRect(_vertices, rect);
	[_verticesBuffer bind];
	glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), _vertices, GL_DYNAMIC_DRAW);
	glVertexPointer(2, GL_FLOAT, 0, 0);
	[_verticesBuffer unbind];
	if (_colored) {
		glEnableClientState(GL_COLOR_ARRAY);
		[_colorBuffer bind];
		glColorPointer(4, GL_FLOAT, 0, 0);
		[_colorBuffer unbind];
	} else {
		glDisableClientState(GL_COLOR_ARRAY);
	}
	if (_textured) {
		[_texture bind];
		[_textureVerticesBuffer bind];
		glTexCoordPointer(2, GL_FLOAT, 0, 0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		[_textureVerticesBuffer unbind];
	}
}

- (void)drawToRect:(CGRect)rect withRotation:(double)radian {
	setTriangleStripVerticesFromRectWithRotation(_vertices, rect, radian);
	[_verticesBuffer bind];
	glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), _vertices, GL_DYNAMIC_DRAW);
	glVertexPointer(2, GL_FLOAT, 0, 0);
	[_verticesBuffer unbind];
	if (_colored) {
		glEnableClientState(GL_COLOR_ARRAY);
		[_colorBuffer bind];
		glColorPointer(4, GL_FLOAT, 0, 0);
		[_colorBuffer unbind];
	} else {
		glDisableClientState(GL_COLOR_ARRAY);
	}
	if (_textured) {
		[_texture bind];
		[_textureVerticesBuffer bind];
		glTexCoordPointer(2, GL_FLOAT, 0, 0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		[_textureVerticesBuffer unbind];
	}
}

@end

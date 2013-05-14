#import "MNGLResources.h"
#import "JZUtility.h"
#import "MNUtility.h"

#define kMNRandomCellTexturePathAreaSize 256
#define kMNRandomCellTextureContextSize (kMNRandomCellTexturePathAreaSize * 3)
#define kMNRandomCellTextureMaxLineWidth (kMNRandomCellTexturePathAreaSize * 0.1)
#define kMNRandomCellTexturePathAreaMin (kMNRandomCellTexturePathAreaSize + kMNRandomCellTextureMaxLineWidth)
#define kMNRandomCellTexturePathAreaMax (kMNRandomCellTextureContextSize - kMNRandomCellTexturePathAreaMin)

static CGLineCap randomLineCap() {
	int type = MNRandomInt(0, 3);
	if (type == 0) {
		return kCGLineCapButt;
	} else if (type == 1) {
		return kCGLineCapRound;
	} else {
		return kCGLineCapSquare;
	}
}

static CGLineJoin randomLineJoin() {
	int type = MNRandomInt(0, 3);
	if (type == 0) {
		return kCGLineJoinBevel;
	} else if (type == 1) {
		return kCGLineJoinMiter;
	} else {
		return kCGLineJoinRound;
	}
}

static void setupContext(CGContextRef context) {
	CGContextSetLineWidth(context, MNRandomDouble(0, kMNRandomCellTextureMaxLineWidth));
	CGContextSetLineCap(context, randomLineCap());
	CGContextSetLineJoin(context, randomLineJoin());
	double strokeColor = MNRandomDouble(0.1, 0.3);
	CGContextSetRGBStrokeColor(context, strokeColor, strokeColor, strokeColor, 1);
	double fillColor = MNRandomDouble(0.8, 1.0);
	CGContextSetRGBFillColor(context, fillColor, fillColor, fillColor, 1);
}

static double maxLengthOfLineFromPointInPathArea(const juiz::Point &start, const juiz::Direction &direction) {
	double angleSin = sin(direction.clockwise_angle_with_above());
	double angleCos = cos(direction.clockwise_angle_with_above());
	if (angleSin == 0) {
		return angleCos > 0 ? kMNRandomCellTexturePathAreaMax - start.y() : start.y() - kMNRandomCellTexturePathAreaMin;
	} else if (angleCos == 0) {
		return angleSin > 0 ? kMNRandomCellTexturePathAreaMax - start.x() : start.x() - kMNRandomCellTexturePathAreaMin;
	} else {
		double xForMaxY = start.x() + angleSin * (angleCos > 0 ? kMNRandomCellTexturePathAreaMax - start.y() : start.y() - kMNRandomCellTexturePathAreaMin);
		if ((angleCos > 0 && xForMaxY <= kMNRandomCellTexturePathAreaMax) || (angleCos < 0 && xForMaxY >= kMNRandomCellTexturePathAreaMin)) {
			return juiz::vector(start, juiz::Point(xForMaxY, angleCos > 0 ? kMNRandomCellTexturePathAreaMax : kMNRandomCellTexturePathAreaMin)).magnitude();
		} else {
			double yForMaxX = start.y() + angleCos * (angleSin > 0 ? kMNRandomCellTexturePathAreaMax - start.x() : start.x() - kMNRandomCellTexturePathAreaMin);
			return juiz::vector(start, juiz::Point(angleSin > 0 ? kMNRandomCellTexturePathAreaMax : kMNRandomCellTexturePathAreaMin, yForMaxX)).magnitude();
		}
	}
}

static void addRandomPath(CGContextRef context) {
	int type = MNRandomInt(0, 3);
	if (type == 0) { // arc
		double radius = MNRandomDouble(0.1, 1) * ((kMNRandomCellTexturePathAreaMax - kMNRandomCellTexturePathAreaMin) / 2);
		double x = MNRandomDouble(kMNRandomCellTexturePathAreaMin + radius, kMNRandomCellTexturePathAreaMax - radius);
		double y = MNRandomDouble(kMNRandomCellTexturePathAreaMin + radius , kMNRandomCellTexturePathAreaMax - radius);
		double radian;
		double radianType = MNRandomInt(0, 100);
		if (radianType < 20) { // circle
			radian = M_PI * 2;
		} else if (radianType < 40) { // half
			radian = M_PI;
		} else if (radianType < 60) { // 1/4
			radian = M_PI_2;
		} else if (radianType < 80) { // 1/8
			radian = M_PI_4;
		} else { // random
			radian = MNRandomDouble(M_PI_4, M_PI * 2);
		}
		double startRadian = MNRandomRadian();
		double endRadian = startRadian + radian;
		if (radian != M_PI * 2) CGContextMoveToPoint(context, x, y);
		CGContextAddArc(context, x, y, radius, startRadian, endRadian, 0);
	} else if (type == 1) { // rect with angle
		const juiz::Point point1(MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax), MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax));
		juiz::Direction direction = juiz::Direction(MNRandomRadian());
		const juiz::Point point2 = juiz::add_vector(point1, juiz::Vector(direction, MNRandomDouble(0.1, 1) * maxLengthOfLineFromPointInPathArea(point1, direction)));
		juiz::Direction orthogonalDirection = juiz::rotate_clockwise(direction, M_PI_2);
		const juiz::Point point3 = juiz::add_vector(point2, juiz::Vector(orthogonalDirection, MNRandomDouble(0.1, 1) * MIN(maxLengthOfLineFromPointInPathArea(point1, orthogonalDirection), maxLengthOfLineFromPointInPathArea(point2, orthogonalDirection))));
		const juiz::Point point4 = juiz::add_vector(point1, juiz::with_direction(juiz::vector(point2, point3), orthogonalDirection));
//		const juiz::Point point3 = JZMovedPoint(point2, angle + M_PI_2, MNRandomDouble(0.1, 1) * MIN(maxLengthOfLineFromPointInPathArea(point1, angle + M_PI_2), maxLengthOfLineFromPointInPathArea(point2, angle + M_PI_2)));
//		const juiz::Point point4 = JZMovedPoint(point1, angle + M_PI_2, juiz::vector(point2, point3).magnitude());
		CGContextMoveToPoint(context, point1.x(), point1.y());
		CGContextAddLineToPoint(context, point2.x(), point2.y());
		CGContextAddLineToPoint(context, point3.x(), point3.y());
		CGContextAddLineToPoint(context, point4.x(), point4.y());
	} else if (type == 2) { // triangle
		CGContextMoveToPoint(context, MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax), MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax));
		CGContextAddLineToPoint(context, MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax), MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax));
		CGContextAddLineToPoint(context, MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax), MNRandomDouble(kMNRandomCellTexturePathAreaMin, kMNRandomCellTexturePathAreaMax));
	}
}

static CGRect drawRandomCellPart(CGContextRef context) {
	setupContext(context);
	CGContextBeginPath(context);
	addRandomPath(context);
	CGRect boundingBox = CGContextGetPathBoundingBox(context);
	CGContextClosePath(context);
	CGPathDrawingMode mode = MNRandomInt(0, 100) < 10 ? kCGPathStroke : kCGPathFillStroke;
	CGContextDrawPath(context, mode);
	return boundingBox;
}

static CGRect drawRandomCellImage(CGContextRef context) {
	CGRect boundingBox = drawRandomCellPart(context);
	int additionalPartsCount = MNRandomInt(0, 2) + MNRandomInt(0, 2) + MNRandomInt(0, 2) + MNRandomInt(0, 2) + MNRandomInt(0, 2);
	for (int i = 0; i < additionalPartsCount; ++i) {
		CGRect partsBoundingBox = drawRandomCellPart(context);
		int left = MIN(boundingBox.origin.x, partsBoundingBox.origin.x);
		int top = MIN(boundingBox.origin.y, partsBoundingBox.origin.y);
		int right = MAX(boundingBox.origin.x + boundingBox.size.width, partsBoundingBox.origin.x + partsBoundingBox.size.width);
		int bottom = MAX(boundingBox.origin.y + boundingBox.size.height, partsBoundingBox.origin.y + partsBoundingBox.size.height);
		boundingBox.origin.x = left;
		boundingBox.origin.y = top;
		boundingBox.size.width = right - left;
		boundingBox.size.height = bottom - top;
	}
	double size = MAX(boundingBox.size.width, boundingBox.size.height) + kMNRandomCellTextureMaxLineWidth;
	double x = MIN(MAX(0, boundingBox.origin.x - (size - boundingBox.size.width) / 2), kMNRandomCellTextureContextSize - size);
	double y = MIN(MAX(0, boundingBox.origin.y - (size - boundingBox.size.height) / 2), kMNRandomCellTextureContextSize - size);
	boundingBox.origin.x = x;
	boundingBox.origin.y = y;
	boundingBox.size.width = size;
	boundingBox.size.height = size;
	return boundingBox;
}

static JZGLTexture *makeRandomCellTexture() {
	CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, kMNRandomCellTextureContextSize, kMNRandomCellTextureContextSize, 8, kMNRandomCellTextureContextSize * 4, imageColorSpace, kCGImageAlphaPremultipliedLast);
	CGRect boundingBox = drawRandomCellImage(context);
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGImageRef imageForTexture = CGImageCreateWithImageInRect(image, CGContextConvertRectToDeviceSpace(context, boundingBox));
	CGImageRelease(image);
	CGContextRelease(context);
	JZGLTexture *texture = [[JZGLTexture alloc] initWithCGImage:imageForTexture];
	CGColorSpaceRelease(imageColorSpace);
	CGImageRelease(imageForTexture);
	return texture;
}

@implementation MNGLResources

@synthesize backgroundTexture = _backgroundTexture;
@synthesize cellEffectBornTexture = _cellEffectBornTexture;
@synthesize cellEffectDieTexture = _cellEffectDieTexture;

- (id)init {
	if (self = [super init]) {
		_backgroundTexture = [[JZGLTexture alloc] initWithImageNamed:@"Background1.png"];
		[self resetCellTextures];
		_cellEffectBornTexture = [[JZGLTexture alloc] initWithImageNamed:@"Cell1EffectBorn.png"];
		_cellEffectDieTexture = [[JZGLTexture alloc] initWithImageNamed:@"Cell1EffectDie.png"];
	}
	return self;
}

- (JZGLTexture *)cellTexture:(int)type {
	return _cellTextures[type];
}

- (void)resetCellTextures {
	for (int i = 0; i < kMNCellTypeCount; ++i) {
		_cellTextures[i] = makeRandomCellTexture();
	}
}

@end

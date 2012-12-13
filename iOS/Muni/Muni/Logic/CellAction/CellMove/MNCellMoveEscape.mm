#import "MNCellMoveEscape.h"
#import "MNCellScanningResult.h"
#import "JZUtility.h"
#import "MNUtility.h"

@implementation MNCellMoveEscape

- (id)initWithCell:(id<MNCell>)cell withCondition:(BOOL (^)(id<MNCell>, id<MNCell>))condition withMoveWhenNotEscape:(MNCellAction *)moveWhenNotEscape {
	if (self = [super init]) {
		_escapeCondition = condition;
		_moveWhenNotEscape = moveWhenNotEscape;
	}
	return self;
}

- (void)sendFrameWithCell:(id<MNCell>)cell withEnvironment:(id<MNEnvironment>)environment {
	NSArray *scanningResults = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
		return _escapeCondition(cell, candidate);
	} withEnvironment:environment];
	if (scanningResults.count > 0) {
		double cellX = cell.center.x();
		double cellY = cell.center.y();
		double maxDistance = cell.radius + cell.sight;
		double xDestination = cellX;
		double yDestination = cellY;
		for (MNCellScanningResult *scanningResult in scanningResults) {
			const juiz::Point pointWithMaxDistance = JZMovedPoint(cell.center, JZRadianFromPoints(cell.center, scanningResult.cell.center), maxDistance);
			xDestination -= pointWithMaxDistance.x() - scanningResult.cell.center.x();
			yDestination -= pointWithMaxDistance.y() - scanningResult.cell.center.y();
		}
		if (cellX > environment.field.size().width() / 2) {
			double distanceToWall = environment.field.size().width() - cellX;
			if (distanceToWall < maxDistance / 2) xDestination = cellX;
		} else {
			if (cellX < maxDistance / 2) xDestination = cellX;
		}
		if (cellY > environment.field.size().height() / 2) {
			double distanceToWall = environment.field.size().height() - cellY;
			if (distanceToWall < maxDistance / 2) yDestination = cellY;
		} else {
			if (cellY < maxDistance / 2) yDestination = cellY;
		}
		double radian;
		if (xDestination == cellX && yDestination == cellY) {
			radian  = MNRandomRadian();
		} else {
			radian = JZRadianFromPoints(cell.center, juiz::Point(xDestination, yDestination));
		}
		[cell moveFor:radian];
		[cell rotateFor:radian];
	} else {
		[_moveWhenNotEscape sendFrameWithCell:cell withEnvironment:environment];
	}
}

@end

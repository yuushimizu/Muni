//
//  MNStandardEnvironment.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNStandardEnvironment.h"
#import "JZUtility.h"

@implementation MNStandardEnvironment

@synthesize field = _field;
@synthesize cells = _cells;

- (id)initWithSize:(CGSize)size withMaxCellCount:(int)maxCellCount {
	if (self = [super init]) {
		_field = [[MNField alloc] initWithSize:size];
		_cells = [NSMutableArray array];
		_maxCellCount = maxCellCount;
		_addedCellsQueue = [NSMutableArray array];
		_incidence = 0.07 * (size.width * size.height) / (480.0 * 320.0);
		_spatialIndex = [[MNSpatialIndex alloc] initWithTotalSize:_field.size withBlockCount:CGSizeMake(16, 16)];
	}
	return self;
}

- (void)updateSpatialIndexFor:(id<MNCell>)cell {
	double radius = cell.radius;
	[_spatialIndex addOrUpdateObject:cell withRect:CGRectMake(cell.center.x - radius, cell.center.y - radius, radius * 2, radius * 2)];
}

- (void)addCell:(id<MNCell>)cell {
	[_addedCellsQueue addObject:cell];
}

- (void)addCellsFromQueue {
	for (id<MNCell> cell in _addedCellsQueue) {
		if (_cells.count >= _maxCellCount) break;
		int cellRadius = cell.radius;
		int index = 0;
		for (id<MNCell> cellStored in _cells) {
			if (cellStored.radius < cellRadius) break;
			index += 1;
		}
		[_cells insertObject:cell atIndex:index];
		[self updateSpatialIndexFor:cell];
	}
	[_addedCellsQueue removeAllObjects];
}

- (NSArray *)cellsInCircle:(CGPoint)center withRadius:(double)radius withCondition:(BOOL (^)(id<MNCell> other))condition {
	NSMutableArray *scanningResults = [NSMutableArray array];
	for (id<MNCell> candidate in [_spatialIndex objectsForRect:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)]) {
		if (candidate.living) {
			double distanceFromCenter = JZDistanceOfPoints(center, candidate.center);
			if (distanceFromCenter - candidate.radius <= radius && (condition == nil || condition(candidate))) {
				double distance = distanceFromCenter - candidate.radius;
				int index = 0;
				for (MNCellScanningResult *scannedResult in scanningResults) {
					if (scannedResult.distance > distance) break;
					index += 1;
				}
				[scanningResults insertObject:[[MNCellScanningResult alloc] initWithCell:candidate withDistance:distance] atIndex:index];
			}
		}
	}
	return scanningResults;
}

- (void)removeDeadCells {
	NSMutableArray *deadCells = [NSMutableArray array];
	for (id<MNCell> cell in _cells) if (!cell.living) [deadCells addObject:cell];
	for (id<MNCell> cell in deadCells) {
		[_cells removeObject:cell];
		[_spatialIndex removeObject:cell];
	}
}

- (void)applyCellsDying {
	for (id<MNCell> deadCell in _cells) {
		if (!deadCell.living) {
			double totalHealEnergy = deadCell.maxEnergy * 0.5;
			NSArray *healTargetScanningResults = [self cellsInCircle:deadCell.center withRadius:deadCell.radius * 3 withCondition:^(id<MNCell> cell){return (BOOL) (deadCell != cell && [cell hostility:deadCell]);}];
			double totalDistance = 0;
			for (MNCellScanningResult *scanningResult in healTargetScanningResults) {
				totalDistance += scanningResult.distance;
			}
			for (MNCellScanningResult *scanningResult in healTargetScanningResults) {
				[scanningResult.cell heal:totalHealEnergy * MIN(scanningResult.distance / totalDistance, 0.5)];
			}
		}
	}
}

- (void)applyCellsHitting {
	NSArray *collisions = [_spatialIndex collisions];
	MNStandardCell * cell1 = nil;
	for (MNStandardCell * cell in collisions) {
		if (cell1 == nil) {
			cell1 = cell;
			continue;
		}
		MNStandardCell * cell2 = cell;
		if (cell1.living && cell2.living) {
			double distance = JZDistanceOfPoints(cell1.center, cell2.center);
			double piledDistance = cell1.radius + cell2.radius - distance;
			if (piledDistance > 0) {
				double radian = JZRadianFromPoints(cell1.center, cell2.center);
				double invertedRadian = JZInvertRadian(radian);
				double weight1 = cell1.weight;
				double weight2 = cell2.weight;
				if ([cell1 hostility:cell2]) {
					[cell1 moveForFix:invertedRadian distance:piledDistance / 2 * (weight2 / (weight1 + weight2))];
					[cell2 moveForFix:radian distance:piledDistance / 2 * (weight1 / (weight2 + weight1))];
					double totalKnockbackDistance = MIN(piledDistance / 2, 5);
					double minKnockbackDistance = totalKnockbackDistance * 0.1;
					double restKnockbackDistance = totalKnockbackDistance - minKnockbackDistance * 2;
					double density1 = cell1.density;
					double density2 = cell2.density;
					if (![cell1 eventOccurredPrevious:kMNCellEventDamaged]) {
						double knockback1 = minKnockbackDistance + (restKnockbackDistance * (density2	/ (density1 + density2)));
						[cell1 moveFor:invertedRadian withForce:knockback1];
						double damage = knockback1 * 50;
						[cell1 damage:damage];
					}
					if (![cell2 eventOccurredPrevious:kMNCellEventDamaged]) {
						double knockback2 = minKnockbackDistance + (restKnockbackDistance * (density1 / (density2 + density1)));
						[cell2 moveFor:radian withForce:knockback2];
						double damage = knockback2 * 50;
						[cell2 damage:damage];
					}
				} else {
					[cell1 moveForFix:invertedRadian distance:piledDistance * (weight2 / (weight1 + weight2))];
					[cell2 moveForFix:radian distance:piledDistance * (weight1 / (weight2 + weight1))];
				}
			}
		}
		cell1 = nil;
	}
}

- (void)sendFrame {
	[self removeDeadCells];
	for (id<MNCell> cell in _cells) [cell sendFrameWithEnvironment:self];
	[self applyCellsHitting];
	[self applyCellsDying];
	for (MNStandardCell *cell in _cells) {
		[cell realMove:self];
		[self updateSpatialIndexFor:cell];
	}
	if (_cells.count < _maxCellCount && (_cells.count < _maxCellCount / 30 || MNRandomDouble(0, _cells.count + 10) < _incidence)) {
		[self addCell:[[MNStandardCell alloc] initByRandomWithEnvironment:self]];
	}
	[self addCellsFromQueue];
}

@end

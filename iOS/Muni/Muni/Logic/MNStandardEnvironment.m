//
//  MNStandardEnvironment.m
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNStandardEnvironment.h"

@implementation MNStandardEnvironment

@synthesize field = _field;
@synthesize cells = _cells;

- (id)initWithSize:(CGSize)size withMaxCellCount:(int)maxCellCount {
	if (self = [super init]) {
		_field = [[MNField alloc] initWithSize:size];
		_cells = [NSMutableArray array];
		_maxCellCount = maxCellCount;
		_addedCellsQueue = [NSMutableArray array];
		_incidence = 0.1;
		_spatialIndex = [[MNSpatialIndex alloc] initWithTotalSize:_field.size withBlockCount:CGSizeMake(8, 8)];
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
			double distanceFromCenter = MNDistanceOfPoints(center, candidate.center);
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
			double totalHealEnergy = deadCell.maxEnergy;
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

- (void)detectCellsHitting:(void (^)(id<MNCell> cell, double damage, double moveRadian, double moveDistance))block {
	NSArray *collisions = [_spatialIndex collisions];
	id<MNCell> cell1 = nil;
	for (id<MNCell> cell in collisions) {
		if (cell1 == nil) {
			cell1 = cell;
			continue;
		}
		id<MNCell> cell2 = cell;
		if (cell1.living && cell2.living) {
			double distance = MNDistanceOfPoints(cell1.center, cell2.center);
			double piledDistance = cell1.radius + cell2.radius - distance;
			if (piledDistance > 0) {
				double moveDistance1 = piledDistance * (cell1.weight / (cell1.weight + cell2.weight));
				double moveDistance2 = piledDistance * (cell2.weight / (cell2.weight + cell1.weight));
				double damage1, damage2;
				if ([cell1 hostility:cell2]) {
					double totalDistance = piledDistance * 5;
					if (![cell1 eventOccurredPrevious:kMNCellEventDamaged]) {
						double knockbackDistance = totalDistance * (cell1.density / (cell1.density + cell2.density));
						moveDistance1 += knockbackDistance;
						damage1 = knockbackDistance * 2;
					} else {
						damage1 = 0;
					}
					if (![cell2 eventOccurredPrevious:kMNCellEventDamaged]) {
						double knockbackDistance = totalDistance * (cell2.density / (cell2.density + cell1.density));
						moveDistance2 += knockbackDistance;
						damage2 = knockbackDistance * 2;
					} else {
						damage2 = 0;
					}
				} else {
					damage1 = damage2 = 0;
				}
				double radian = MNRadianFromPoints(cell1.center, cell2.center);
				block(cell1, damage1, MNInvertRadian(radian), moveDistance1);
				block(cell2, damage2, radian, moveDistance2);
			}
		}
		cell1 = nil;
	}
}

- (void)applyCellsHitting {
	NSMutableSet *cellsMoved = [NSMutableSet set];
	[self detectCellsHitting:^(id<MNCell> cell, double damage, double moveRadian, double moveDistance) {
		[cell moveFor:moveRadian distance:MIN(moveDistance, cell.radius * 0.5) withEnvironment:self];
		if (damage > 0) [cell damage:damage];
		[cellsMoved addObject:cell];
	}];
	for (id<MNCell> cell in cellsMoved) [self updateSpatialIndexFor:cell];
}

- (void)sendFrame {
	[self removeDeadCells];
	for (id<MNCell> cell in _cells) {
		[cell sendFrameWithEnvironment:self];
		[self updateSpatialIndexFor:cell];
	}
	[self applyCellsHitting];
	[self applyCellsDying];
	if (_cells.count < _maxCellCount && MNRandomDouble(0, _cells.count + 1) < _incidence) {
		[self addCell:[[MNStandardCell alloc] initByRandomWithEnvironment:self]];
	}
	[self addCellsFromQueue];
}

@end

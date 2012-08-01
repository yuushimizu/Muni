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
		_incidence = 0.13;
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
			double distance = MNDistanceOfPoints(cell1.center, cell2.center);
			double piledDistance = cell1.radius + cell2.radius - distance;
			if (piledDistance > 0) {
				double radian = MNRadianFromPoints(cell1.center, cell2.center);
				double invertedRadian = MNInvertRadian(radian);
				double weight1 = cell1.weight;
				double weight2 = cell2.weight;
				[cell1 moveForFix:invertedRadian distance:piledDistance * (weight2 / (weight1 + weight2))];
				[cell2 moveForFix:radian distance:piledDistance * (weight1 / (weight2 + weight1))];
				if ([cell1 hostility:cell2]) {
					double totalKnockedbackdDistance = MAX(cell1.lastMovedDistance * cos(radian - cell1.lastMovedRadian) + cell2.lastMovedDistance * cos(invertedRadian - cell2.lastMovedRadian) * 2, MIN(cell1.radius, cell2.radius) * 0.25);
					double minKnockedbackDistance = totalKnockedbackdDistance * 0.1;
					double restKnockedbackDistance = totalKnockedbackdDistance * 0.8;
					double density1 = cell1.density;
					double density2 = cell2.density;
					if (![cell1 eventOccurredPrevious:kMNCellEventDamaged]) {
						double knockedback1 = minKnockedbackDistance + (restKnockedbackDistance * (density2	/ (density1 + density2)));
						[cell1 moveFor:invertedRadian withForce:knockedback1];
						[cell1 damage:knockedback1 * 10];
					}
					if (![cell2 eventOccurredPrevious:kMNCellEventDamaged]) {
						double knockedback2 = minKnockedbackDistance + (restKnockedbackDistance * (density1 / (density2 + density1)));
						[cell2 moveFor:radian withForce:knockedback2];
						[cell2 damage:knockedback2 * 10];
					}
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
	if (_cells.count < _maxCellCount && MNRandomDouble(0, _cells.count + 1) < _incidence) {
		[self addCell:[[MNStandardCell alloc] initByRandomWithEnvironment:self]];
	}
	[self addCellsFromQueue];
}

@end

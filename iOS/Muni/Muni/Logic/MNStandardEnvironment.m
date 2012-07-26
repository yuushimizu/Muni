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
		_incidence = 0.1;
		_spatialIndex = [[MNSpatialIndex alloc] initWithTotalSize:_field.size withBlockCount:CGSizeMake(8, 8)];
	}
	return self;
}

- (void)addCellToSpatialIndex:(id<MNCell>)cell {
	double radius = cell.radius;
	[_spatialIndex addObject:cell forRect:CGRectMake(cell.center.x - radius, cell.center.x + radius, cell.center.y - radius, cell.center.y + radius)];
}

- (void)updateSpatialIndexFor:(id<MNCell>)cell {
	[_spatialIndex removeObject:cell];
	[self addCellToSpatialIndex:cell];
}

- (void)addCell:(id<MNCell>)cell {
	if (_cells.count >= _maxCellCount) return;
	int cellRadius = cell.radius;
	int index;
	for (index = 0; index < _cells.count; ++index) {
		id<MNCell> cellStored = [_cells objectAtIndex:index];
		if (cellStored.radius < cellRadius) {
			break;
		}
	}
	[_cells insertObject:cell atIndex:index];
	[self addCellToSpatialIndex:cell];
}

- (void)removeDeadCells {
	NSMutableArray *deadCells = [NSMutableArray array];
	for (id<MNCell> cell in _cells) if (!cell.living) [deadCells addObject:cell];
	for (id<MNCell> cell in deadCells) {
		[_cells removeObject:cell];
		[_spatialIndex removeObject:cell];
	}
}

- (NSArray *)cellsHittedWith:(id<MNCell>)cell {
	NSMutableArray *cells = [NSMutableArray array];
	double radius = cell.radius;
	for (id<MNCell> candidateCell in [_spatialIndex objectsPiledWith:cell]) {
		if (cell != candidateCell
			&& candidateCell.living
			&& [[MNPointIntervalByPoints alloc] initWithSource:cell.center withDestination:candidateCell.center].distance <= radius + candidateCell.radius) {
			[cells addObject:candidateCell];
		}
	}
	return cells;
}

- (NSArray *)detectCellsHitting {
	NSMutableArray *cellHittingEffects = [NSMutableArray array];
	for (id<MNCell> cell in _cells) {
		if (cell.living) {
			double radius = cell.radius;
			double weight = cell.weight;
			for (id<MNCell> cellHitted in [self cellsHittedWith:cell]) {
				MNPointIntervalByPoints *interval = [[MNPointIntervalByPoints alloc] initWithSource:cellHitted.center withDestination:cell.center];
				double moveDistance = (radius + cellHitted.radius - interval.distance) * (weight / (weight + cellHitted.weight));
				[cellHittingEffects addObject:[[MNCellHittingEffect alloc] initWithCell:cell withMoveRadian:interval.radian withMoveDistance:moveDistance]];
			}
		}
	}
	return cellHittingEffects;
}

- (void)applyCellsHitting {
	NSMutableSet *cellsMoved = [NSMutableSet set];
	for (MNCellHittingEffect *cellHittingEffect in [self detectCellsHitting]) {
		id<MNCell> cell = cellHittingEffect.cell;
		[cell moveFor:cellHittingEffect.moveRadian distance:cellHittingEffect.moveDistance];
		[cellsMoved addObject:cell];
	}
	for (id<MNCell> cell in cellsMoved) [self updateSpatialIndexFor:cell];
}

- (void)sendFrame {
	[self removeDeadCells];
	for (id<MNCell> cell in _cells) {
		[cell sendFrame];
		[self updateSpatialIndexFor:cell];
	}
	[self applyCellsHitting];
	if (_cells.count < _maxCellCount && MNRandomDouble(0, _cells.count + 1) < _incidence) {
		[self addCell:[[MNStandardCell alloc] initByRandomWithEnvironment:self]];
	}
}

@end

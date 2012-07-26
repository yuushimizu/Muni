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
	[_spatialIndex addObject:cell forRect:CGRectMake(cell.center.x - radius, cell.center.y - radius, radius * 2, radius * 2)];
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

- (NSArray *)detectCellsHitting {
	NSMutableArray *cellHittingEffects = [NSMutableArray array];
	for (MNSpatialIndexPile *pile in [_spatialIndex piles]) {
		id<MNCell> cell1 = pile.object1;
		id<MNCell> cell2 = pile.object2;
		if (cell1.living && cell2.living) {
			MNPointIntervalByPoints *interval = [[MNPointIntervalByPoints alloc] initWithSource:cell1.center withDestination:cell2.center];
			double piledDistance = cell1.radius + cell2.radius - interval.distance;
			if (piledDistance > 0) {
				[cellHittingEffects addObject:[[MNCellHittingEffect alloc] initWithCell:cell1 withMoveRadian:MNInvertRadian(interval.radian) withMoveDistance:piledDistance * (cell1.weight / (cell1.weight + cell2.weight))]];
				[cellHittingEffects addObject:[[MNCellHittingEffect alloc] initWithCell:cell2 withMoveRadian:interval.radian withMoveDistance:piledDistance * (cell2.weight / (cell2.weight + cell1.weight))]];
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

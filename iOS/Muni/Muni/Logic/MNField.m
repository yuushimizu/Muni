//
//  MNField.m
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNField.h"

@implementation MNField

@synthesize cells = _cells;

- (id)initWithSize:(CGSize)size withMaxCellCount:(int)maxCellCount {
	if (self = [super initWithSize:size]) {
		_cells = [NSMutableArray array];
		_maxCellCount = maxCellCount;
		_incidence = 0.1;
	}
	return self;
}

- (void)addCell:(MNCell *)cell {
	if (_cells.count >= _maxCellCount) return;
	int cellRadius = cell.radius;
	int index;
	for (index = 0; index < _cells.count; ++index) {
		MNCell *cellStored = [_cells objectAtIndex:index];
		if (cellStored.radius < cellRadius) {
			break;
		}
	}
	[_cells insertObject:cell atIndex:index];
}

- (void)removeDeadCells {
	NSMutableArray *deadCells = [NSMutableArray array];
	for (MNCell *cell in _cells) if (!cell.living) [deadCells addObject:cell];
	for (MNCell *cell in deadCells) [_cells removeObject:cell];
}

- (void)sendFrame {
	[self removeDeadCells];
	for (MNCell *cell in _cells) [cell sendFrame];
	if (_cells.count < _maxCellCount && MNRandomDouble(0, _cells.count + 1) < _incidence) {
		[self addCell:[[MNCell alloc] initByRandomWithField:self]];
	}
}

@end

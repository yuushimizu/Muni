//
//  MNField.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUtility.h"
#import "MNBaseField.h"
#import "MNCell.h"

@interface MNField : MNBaseField {
	NSMutableArray *_cells;
	int _maxCellCount;
	double _incidence;
}

@property (readonly) NSArray *cells;

- (id)initWithSize:(CGSize)size withMaxCellCount:(int)maxCellCount;

- (void)sendFrame;

@end

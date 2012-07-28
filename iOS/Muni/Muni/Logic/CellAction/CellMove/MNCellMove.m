//
//  MNCellMove.m
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCellMove.h"

@implementation MNCellMove

- (CGPoint)pointMoved {
	return self.cell.center;
}

- (void)sendFrame {
	[self.cell moveTo:[self pointMoved]];
}

@end

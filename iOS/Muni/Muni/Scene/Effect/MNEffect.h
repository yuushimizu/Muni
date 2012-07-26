//
//  MNEffect.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNEffect : NSObject {
	CGPoint _center;
	double _age;
	BOOL _living;
}

@property (readonly) CGPoint center;
@property (readonly) double age;
@property (readonly) BOOL living;

- (id)initWithCenter:(CGPoint)center;
- (void)die;
- (void)sendFrame;
- (void)draw;

@end

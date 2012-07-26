//
//  MNCellBornEffect.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNEffect.h"
#import "JZGLSprite.h"
#import "MNCell.h"
#import "MNGLResources.h"

@interface MNCellBornEffect : MNEffect {
	double _initialRadius;
	JZGLSprite *_sprite;
}

- (id)initWithCell:(id<MNCell>)cell withResources:(MNGLResources *)resources;

@end

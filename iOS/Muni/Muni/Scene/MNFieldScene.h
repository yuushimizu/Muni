//
//  MNFieldScene.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZScene.h"
#import "MNField.h"
#import "MNGLResources.h"
#import "JZGLSprite.h"
#import "MNEffect.h"
#import "MNCellBornEffect.h"
#import "MNCellDieEffect.h"

#define kMNMaxCells 50

@interface MNFieldScene : NSObject<JZScene> {
	MNField *_field;
	MNGLResources *_resources;
	JZGLSprite *_backgroundSprite;
	int _xBackgroundTileCount;
	int _yBackgroundTileCount;
	JZGLSprite *_cellSprites[kMNMaxCells];
	NSMutableSet *_effects;
}

- (id)initWithSize:(CGSize)size;

@end

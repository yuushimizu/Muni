//
//  MNFieldScene.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZScene.h"
#import "MNStandardEnvironment.h"
#import "MNStandardCell.h"
#import "MNField.h"
#import "MNGLResources.h"
#import "JZGLSprite.h"
#import "MNEffect.h"
#import "MNCellBornEffect.h"
#import "MNCellDieEffect.h"

#define kMNMaxCells 100

@interface MNFieldScene : NSObject<JZScene> {
	MNStandardEnvironment *_environment;
	MNGLResources *_resources;
	JZGLSprite *_backgroundSprite;
	JZGLSprite *_cellSprites[kMNMaxCells];
	NSMutableArray *_effects;
	BOOL _firstMessageIsShown;
}

- (BOOL)firstMessageIsShownInPast;
- (void)markAsShownFirstMessage;
- (id)initWithSize:(CGSize)size;

@end

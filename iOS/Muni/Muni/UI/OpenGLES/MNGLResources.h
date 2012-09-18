//
//  MNGLResources.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZGLTexture.h"
#import "MNCell.h"

@interface MNGLResources : NSObject {
	JZGLTexture *_backgroundTexture;
	JZGLTexture *_cellTextures[kMNCellTypeCount];
	JZGLTexture *_cellEffectBornTexture;
	JZGLTexture *_cellEffectDieTexture;
}

@property (readonly) JZGLTexture *backgroundTexture;
@property (readonly) JZGLTexture *cellEffectBornTexture;
@property (readonly) JZGLTexture *cellEffectDieTexture;

- (JZGLTexture *)cellTexture:(int)type;
- (void)resetCellTextures;

@end

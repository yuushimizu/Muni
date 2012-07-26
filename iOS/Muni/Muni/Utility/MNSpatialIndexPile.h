//
//  MNSpatialIndexPile.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNSpatialIndexPile : NSObject {
	id _object1;
	id _object2;
}

@property (readonly) id object1;
@property (readonly) id object2;

- (id)initWithObject1:(id)object1 withObject2:(id)object2;

@end

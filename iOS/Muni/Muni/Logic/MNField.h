//
//  MNField.h
//  Muni
//
//  Created by Yuu Shimizu on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUtility.h"

@interface MNField : NSObject {
	CGSize _size;
}

@property (readonly) CGSize size;

- (id)initWithSize:(CGSize)size;

@end
